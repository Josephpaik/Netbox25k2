# 기타 매개변수

## ADMINS

NetBox는 중요한 오류에 대한 세부 정보를 여기에 나열된 관리자에게 이메일로 보냅니다. 이것은 (이름, 이메일) 튜플의 목록이어야 합니다. 예:

```python
ADMINS = [
    ['Hank Hill', 'hhill@example.com'],
    ['Dale Gribble', 'dgribble@example.com'],
]
```

---

## BANNER_BOTTOM

!!! tip "동적 구성 매개변수"

사용자 인터페이스의 하단 배너에 대한 콘텐츠를 설정합니다.

---

## BANNER_LOGIN

!!! tip "동적 구성 매개변수"

로그인 양식 위에 로그인 페이지에 표시할 사용자 정의 콘텐츠를 정의합니다. HTML이 허용됩니다.

---

## BANNER_MAINTENANCE

!!! tip "동적 구성 매개변수"

유지 관리 모드가 활성화되면 모든 페이지 상단에 배너를 추가합니다. HTML이 허용됩니다.

---

## BANNER_TOP

!!! tip "동적 구성 매개변수"

사용자 인터페이스의 상단 배너에 대한 콘텐츠를 설정합니다.

!!! tip
    상단 및 하단 배너를 일치시키려면 다음을 설정하세요:

    ```python
    BANNER_TOP = 'Your banner text'
    BANNER_BOTTOM = BANNER_TOP
    ```

---

## CENSUS_REPORTING_ENABLED

기본값: `True`

익명 인구 조사 보고를 활성화합니다. 인구 조사 보고를 거부하려면 `False`로 설정하세요.

이 데이터를 통해 프로젝트 관리자는 얼마나 많은 NetBox 배포가 존재하는지 추정하고 시간이 지남에 따라 새 버전 채택을 추적할 수 있습니다. 인구 조사 보고는 작업자가 시작될 때마다 단일 HTTP 요청을 수행합니다. 이 기능에서 보고되는 유일한 데이터는 NetBox 버전, Python 버전 및 의사 난수 고유 식별자입니다.

---

## CHANGELOG_RETENTION

!!! tip "동적 구성 매개변수"

기본값: `90`

기록된 변경 사항(객체 생성, 업데이트 및 삭제)을 보존할 일수입니다. 변경 사항을 데이터베이스에 무기한 보존하려면 `0`으로 설정하세요.

!!! warning
    무기한 변경 로그 보존을 활성화하는 경우 주기적으로 오래된 항목을 삭제하는 것이 좋습니다. 그렇지 않으면 데이터베이스 용량이 초과될 수 있습니다.

---

## CHANGELOG_SKIP_EMPTY_CHANGES

기본값: `True`

활성화하면 기존 필드 값에 대한 변경 사항 없이 객체가 업데이트될 때 변경 로그 레코드가 생성되지 않습니다.

!!! note
    객체의 `last_updated` 필드는 이 매개변수에 관계없이 항상 가장 최근 업데이트 시간을 반영합니다.

---

## DATA_UPLOAD_MAX_MEMORY_SIZE

기본값: `2621440` (2.5 MB)

수신 HTTP 요청(즉, `GET` 또는 `POST` 데이터)의 최대 크기(바이트)입니다. 이 크기를 초과하는 요청은 `RequestDataTooBig` 예외를 발생시킵니다.

---

## ENFORCE_GLOBAL_UNIQUE

!!! tip "동적 구성 매개변수"

기본값: `True`

기본적으로 NetBox는 전역 테이블(즉, VRF에 할당되지 않은 것)에서 중복 프리픽스 및 IP 주소 생성을 방지합니다. 이 유효성 검사는 `ENFORCE_GLOBAL_UNIQUE`를 `False`로 설정하여 비활성화할 수 있습니다.

---

## EVENTS_PIPELINE

기본값: `['extras.events.process_event_queue',]`

NetBox는 모델에 대한 이벤트(생성, 업데이트, 삭제) 및 사용자 정의 EventRule이 트리거될 때 여기에 나열된 함수에 대한 점으로 구분된 경로를 호출합니다.

---

## FILE_UPLOAD_MAX_MEMORY_SIZE

기본값: `2621440` (2.5 MB)

파일 시스템에 기록되기 전에 메모리에 보관될 업로드된 데이터의 최대 양(바이트)입니다. 이 설정을 변경하면 예를 들어 처리를 위해 사용자 정의 스크립트에 2.5MB보다 큰 파일을 업로드할 수 있습니다.

---

## JOB_RETENTION

!!! tip "동적 구성 매개변수"

기본값: `90`

작업 결과(스크립트 및 보고서)를 보존할 일수입니다. 작업 결과를 데이터베이스에 무기한 보존하려면 `0`으로 설정하세요.

!!! warning
    무기한 작업 결과 보존을 활성화하는 경우 주기적으로 오래된 항목을 삭제하는 것이 좋습니다. 그렇지 않으면 데이터베이스 용량이 초과될 수 있습니다.

---

## MAINTENANCE_MODE

!!! tip "동적 구성 매개변수"

기본값: `False`

이것을 `True`로 설정하면 모든 페이지 상단에 "유지 관리 모드" 배너가 표시됩니다. 또한 NetBox는 더 이상 로그인 시 사용자의 "마지막 활성" 시간을 업데이트하지 않습니다. 이는 데이터베이스가 읽기 전용 상태일 때 새 로그인을 허용하기 위한 것입니다. 유지 관리 모드가 비활성화되면 로그인 시간 기록이 재개됩니다.

---

## MAPS_URL

!!! tip "동적 구성 매개변수"

기본값: `https://maps.google.com/?q=` (Google Maps)

도로명 주소 또는 GPS 좌표로 물리적 위치의 지도를 표시할 때 사용할 URL을 지정합니다. URL은 자유 형식 도로명 주소 또는 쉼표로 구분된 숫자 좌표 쌍을 추가로 받아야 합니다. UI 내에서 "지도 보기" 버튼을 비활성화하려면 `None`으로 설정하세요.

---

## MAX_PAGE_SIZE

!!! tip "동적 구성 매개변수"

기본값: `1000`

웹 사용자 또는 API 소비자는 URL에 "limit" 매개변수를 추가하여 임의의 수의 객체를 요청할 수 있습니다(예: `?limit=1000`). 이 매개변수는 허용 가능한 최대 제한을 정의합니다. `0` 또는 `None`으로 설정하면 클라이언트가 `?limit=0`을 지정하여 제한 없이 _모든_ 일치하는 객체를 한 번에 검색할 수 있습니다.

---

## METRICS_ENABLED

기본값: `False`

`/metrics`에서 Prometheus 호환 메트릭의 가용성을 전환합니다. 자세한 내용은 [Prometheus 메트릭](../integrations/prometheus-metrics.md) 문서를 참조하세요.

---

## PREFER_IPV4

!!! tip "동적 구성 매개변수"

기본값: `False`

장비의 기본 IP 주소를 결정할 때 기본적으로 IPv6가 IPv4보다 선호됩니다. 대신 IPv4를 선호하려면 `True`로 설정하세요.

---

## QUEUE_MAPPINGS

백그라운드 작업에 내부적으로 사용되는 대기열을 변경할 수 있습니다.

```python
QUEUE_MAPPINGS = {
    'webhook': 'low',
    'report': 'high',
    'script': 'high',
}
```

대기열이 정의되지 않으면 `default`라는 대기열이 사용됩니다.

---

## RELEASE_CHECK_URL

기본값: `None` (비활성화)

이 매개변수는 새 NetBox 릴리스를 확인할 저장소의 URL을 정의합니다. 새 릴리스가 감지되면 홈페이지에서 관리 사용자에게 메시지가 표시됩니다. 공식 저장소(`'https://api.github.com/repos/netbox-community/netbox/releases'`) 또는 사용자 정의 포크로 설정할 수 있습니다. 자동 업데이트 확인을 비활성화하려면 `None`으로 설정하세요.

!!! note
    제공된 URL은 [GitHub REST API](https://docs.github.com/en/rest)와 호환되어야 **합니다**.

---

## RQ_DEFAULT_TIMEOUT

기본값: `300`

백그라운드 작업(예: 사용자 정의 스크립트 실행)의 최대 실행 시간(초)입니다.

---

## RQ_RETRY_INTERVAL

기본값: `60`

이 매개변수는 `RQ_RETRY_MAX`로 지정된 최대 횟수까지 실패한 작업이 재시도되는 빈도를 제어합니다. 이것은 연속 시도 사이에 대기할 초 수를 지정하는 정수이거나 이러한 값의 목록이어야 합니다. 예를 들어, `[60, 300, 3600]`은 1분, 5분, 1시간 후에 작업을 재시도합니다.

---

## RQ_RETRY_MAX

기본값: `0` (재시도 비활성화)

백그라운드 작업이 실패로 표시되기 전에 재시도되는 최대 횟수입니다.

## DISK_BASE_UNIT

기본값: `1000`

디스크 크기의 기본 단위입니다. 10진수 접두사(MB, GB 등) 대신 이진 접두사(MiB, GiB 등)를 사용하려면 `1024`로 설정하세요.

## RAM_BASE_UNIT

기본값: `1000`

RAM 크기의 기본 단위입니다. 10진수 접두사(MB, GB 등) 대신 이진 접두사(MiB, GiB 등)를 사용하려면 `1024`로 설정하세요.
