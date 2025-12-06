# 웹훅

NetBox는 [이벤트 규칙](../features/event-rules.md)을 통해 내부 객체 변경에 대한 응답으로 원격 시스템에 발신 웹훅을 전송하도록 구성할 수 있습니다. 수신자는 이러한 웹훅 메시지의 데이터를 사용하여 관련 작업을 수행할 수 있습니다.

예를 들어 장비의 운영 상태가 활성으로 변경되면 모니터링 시스템이 자동으로 해당 장비 모니터링을 시작하고, 다른 상태의 경우 모니터링에서 제거하도록 구성하려고 한다고 가정합니다. NetBox에서 장비 모델에 대한 웹훅을 생성하고 수신 시스템에서 원하는 변경을 수행하기 위해 콘텐츠와 대상 URL을 작성할 수 있습니다. 구성된 제약 조건이 충족될 때마다 NetBox에서 웹훅이 자동으로 전송됩니다.

!!! warning "보안 주의사항"
    웹훅은 URL, 사용자 정의 헤더 및 페이로드를 생성하기 위해 사용자가 제출한 코드를 포함하는 것을 지원하며, 이는 특정 조건에서 보안 위험을 초래할 수 있습니다. 신뢰할 수 있는 사용자에게만 웹훅을 생성하거나 수정할 수 있는 권한을 부여하세요.

## Jinja2 템플릿 지원

[Jinja2 템플릿](https://jinja.palletsprojects.com/)은 `URL`, `additional_headers` 및 `body_template` 필드에 지원됩니다. 이를 통해 사용자는 요청 헤더에 객체 데이터를 전달하고 사용자 정의된 요청 본문을 작성할 수 있습니다. 발신 메시지가 수신자가 기대하고 이해하는 형식인지 확인하여 외부 시스템과의 직접적인 상호 작용을 활성화하도록 요청 콘텐츠를 작성할 수 있습니다.

예를 들어 IP 주소가 생성될 때마다 [Slack 메시지를 트리거](https://api.slack.com/messaging/webhooks)하는 NetBox 웹훅을 생성할 수 있습니다. 다음 구성을 사용하여 이를 수행할 수 있습니다:

* 객체 유형: IPAM > IP 주소
* HTTP 메서드: `POST`
* URL: Slack 수신 웹훅 URL
* HTTP 콘텐츠 유형: `application/json`
* 본문 템플릿: `{"text": "IP address {{ data['address'] }} was created by {{ username }}!"}`

### 사용 가능한 컨텍스트

Jinja2 템플릿의 컨텍스트로 다음 데이터를 사용할 수 있습니다:

* `event` - 웹훅을 트리거한 이벤트 유형: created, updated 또는 deleted.
* `model` - 변경을 트리거한 NetBox 모델.
* `timestamp` - 이벤트가 발생한 시간([ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) 형식).
* `username` - 변경과 연관된 사용자 계정의 이름.
* `request_id` - 고유 요청 ID. 단일 요청과 연관된 여러 변경을 상관시키는 데 사용할 수 있습니다.
* `data` - 현재 상태의 객체에 대한 상세 표현. 일반적으로 NetBox REST API에서 모델의 표현과 동일합니다.
* `snapshots` - 변경 전후의 객체 상태에 대한 최소 "스냅샷"; `prechange` 및 `postchange`라는 키가 있는 딕셔너리로 제공됩니다. 완전히 직렬화된 표현만큼 광범위하지는 않지만 변경된 내용을 전달하기에 충분한 정보를 포함합니다.

### 기본 요청 본문

본문 템플릿이 지정되지 않으면 요청 본문에 컨텍스트 데이터가 포함된 JSON 객체가 채워집니다. 예를 들어 새로 생성된 사이트는 다음과 같이 나타날 수 있습니다:

```json
{
    "event": "created",
    "timestamp": "2021-03-09 17:55:33.968016+00:00",
    "model": "site",
    "username": "jstretch",
    "request_id": "fdbca812-3142-4783-b364-2e2bd5c16c6a",
    "data": {
        "id": 19,
        "name": "Site 1",
        "slug": "site-1",
        "status":
            "value": "active",
            "label": "Active",
            "id": 1
        },
        "region": null,
        ...
    },
    "snapshots": {
        "prechange": null,
        "postchange": {
            "created": "2021-03-09",
            "last_updated": "2021-03-09T17:55:33.851Z",
            "name": "Site 1",
            "slug": "site-1",
            "status": "active",
            ...
        }
    }
}
```

!!! note
    조건부 웹훅 설정은 NetBox 3.7부터 [이벤트 규칙](../features/event-rules.md)으로 이동되었습니다.

## 웹훅 처리

[이벤트 규칙](../features/event-rules.md)을 사용하여 변경이 감지되면 결과 웹훅이 처리를 위해 Redis 큐에 배치됩니다. 이를 통해 사용자 요청이 발신 웹훅 처리를 기다릴 필요 없이 완료할 수 있습니다. 그런 다음 웹훅은 `rqworker` 프로세스에 의해 큐에서 추출되고 HTTP 요청이 각 대상으로 전송됩니다. 현재 웹훅 큐와 실패한 웹훅은 시스템 > 백그라운드 작업에서 검사할 수 있습니다.

응답에 2XX 상태 코드가 있으면 요청이 성공한 것으로 간주됩니다. 그렇지 않으면 요청이 실패한 것으로 표시됩니다. 실패한 요청은 시스템 > 백그라운드 작업에서 수동으로 다시 큐에 넣을 수 있습니다.

## 문제 해결

발신 웹훅의 콘텐츠가 올바르게 렌더링되는지 확인하는 데 도움이 되도록 NetBox는 웹훅 요청을 수신하고 표시하기 위해 로컬에서 실행할 수 있는 간단한 HTTP 리스너를 제공합니다. 먼저 원하는 웹훅의 대상 URL을 `http://localhost:9000/`으로 수정합니다. 이렇게 하면 NetBox가 TCP 포트 9000의 로컬 서버로 요청을 보내도록 지시합니다. 그런 다음 NetBox 루트 디렉토리에서 웹훅 수신기 서비스를 시작합니다:

```no-highlight
$ python netbox/manage.py webhook_receiver
Listening on port http://localhost:9000. Stop with CONTROL-C.
```

HTTP 요청을 보내 수신기 자체를 테스트할 수 있습니다. 예:

```no-highlight
$ curl -X POST http://localhost:9000 --data '{"foo": "bar"}'
```

서버는 다음과 유사한 출력을 인쇄합니다:

```no-highlight
[1] Tue, 07 Apr 2020 17:44:02 GMT 127.0.0.1 "POST / HTTP/1.1" 200 -
Host: localhost:9000
User-Agent: curl/7.58.0
Accept: */*
Content-Length: 14
Content-Type: application/x-www-form-urlencoded

{"foo": "bar"}
------------
```

`webhook_receiver`는 실제로 수신된 정보로 아무것도 _하지_ 않습니다. 단지 검사를 위해 요청 헤더와 본문을 인쇄합니다. 출력이 표시되지 않으면 `rqworker` 프로세스가 실행 중이고 웹훅 이벤트가 큐에 배치되고 있는지 확인하세요.

웹훅 결과는 NetBox 관리 UI의 백그라운드 작업 섹션에서 찾을 수 있습니다. 완료되거나 실패한 실행과 실패한 웹훅에 대한 오류 로그를 볼 수 있습니다.
