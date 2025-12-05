# API 및 통합

NetBox에는 네트워크를 구동하는 다른 도구 및 리소스와의 통합을 가능하게 하는 다양한 기능이 포함되어 있습니다.

## REST API

[Django REST Framework](https://www.django-rest-framework.org/)로 구동되는 NetBox의 REST API는 객체 생성, 수정 및 삭제를 위한 강력하면서도 접근하기 쉬운 인터페이스를 제공합니다. 전송에 HTTP를, 데이터 캡슐화에 JSON을 사용하는 REST API는 모든 플랫폼의 클라이언트에서 쉽게 사용할 수 있으며 자동화 작업에 매우 적합합니다.

```no-highlight
curl -s -X POST \
-H "Authorization: Token $TOKEN" \
-H "Content-Type: application/json" \
http://netbox/api/ipam/prefixes/ \
--data '{"prefix": "192.0.2.0/24", "site": {"name": "Branch 12"}}'
```

REST API는 API 클라이언트를 사용자 계정과 할당된 권한에 매핑하는 토큰 기반 인증을 사용합니다. API 엔드포인트는 OpenAPI를 사용하여 완전히 문서화되어 있으며, NetBox에는 탐색을 위한 편리한 브라우저 기반 API 버전도 포함되어 있습니다. 오픈 소스 [pynetbox](https://github.com/netbox-community/pynetbox) 및 [go-netbox](https://github.com/netbox-community/go-netbox) API 클라이언트 라이브러리도 Python과 Go용으로 각각 제공됩니다.

이 기능에 대해 자세히 알아보려면 [REST API 문서](../integrations/rest-api.md)를 확인하세요.

## GraphQL API

NetBox는 REST API를 보완하기 위해 [GraphQL](https://graphql.org/) API도 제공합니다. GraphQL은 임의의 객체와 필드에 대한 복잡한 쿼리를 가능하게 하여 클라이언트가 NetBox에서 필요한 특정 데이터만 검색할 수 있게 합니다. 이것은 효율적인 쿼리를 위한 특수 목적의 읽기 전용 API입니다. REST API와 마찬가지로 GraphQL API도 토큰 기반 인증을 사용합니다.

이 기능에 대해 자세히 알아보려면 [GraphQL API 문서](../integrations/graphql-api.md)를 확인하세요.

## 웹훅

웹훅은 NetBox에서 발생한 변경 사항을 일부 외부 시스템에 전달하는 메커니즘입니다. 예를 들어 NetBox에서 장비의 상태가 업데이트될 때마다 모니터링 시스템에 알리고 싶을 수 있습니다. 이를 위해 먼저 원격 수신기(URL), HTTP 메서드 및 기타 필요한 매개변수를 식별하는 [웹훅](../models/extras/webhook.md)을 생성합니다. 그런 다음 웹훅을 전송하기 위해 장비 변경에 의해 트리거되는 [이벤트 규칙](../models/extras/eventrule.md)을 정의합니다.

NetBox가 장비에 대한 변경을 감지하면 변경 사항의 세부 정보와 변경한 사람이 포함된 HTTP 요청이 지정된 수신기로 전송됩니다. 웹훅은 이벤트 기반 자동화 프로세스를 구축하기 위한 훌륭한 메커니즘입니다. 이 기능에 대해 자세히 알아보려면 [웹훅 문서](../integrations/webhooks.md)를 확인하세요.

## Prometheus 메트릭

NetBox에는 오픈 소스 [django-prometheus](https://github.com/korfuri/django-prometheus) 라이브러리로 구동되는 [Prometheus](https://prometheus.io/) 스크레이퍼용 메트릭을 노출하는 특별한 `/metrics` 뷰가 포함되어 있습니다. 이 기능에 대해 자세히 알아보려면 [Prometheus 메트릭 문서](../integrations/prometheus-metrics.md)를 확인하세요.
