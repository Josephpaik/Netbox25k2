# REST API 개요

## REST API란?

REST는 [Representational State Transfer](https://en.wikipedia.org/wiki/REST)의 약자입니다. HTTP 요청과 [JavaScript Object Notation (JSON)](https://www.json.org/)을 사용하여 애플리케이션 내 객체에 대한 생성, 조회, 수정, 삭제(CRUD) 작업을 용이하게 하는 특정 유형의 API입니다. 각 작업 유형은 특정 HTTP 동사와 연관됩니다:

* `GET`: 객체 또는 객체 목록 조회
* `POST`: 객체 생성
* `PUT` / `PATCH`: 기존 객체 수정. `PUT`은 모든 필수 필드를 지정해야 하고, `PATCH`는 수정하는 필드만 지정하면 됩니다.
* `DELETE`: 기존 객체 삭제

추가로 `OPTIONS` 동사를 사용하여 특정 REST API 엔드포인트를 검사하고 지원되는 모든 작업과 사용 가능한 매개변수를 반환할 수 있습니다.

REST API의 주요 장점 중 하나는 사람 친화적이라는 것입니다. HTTP와 JSON을 활용하기 때문에 일반적인 도구를 사용하여 명령줄에서 NetBox 데이터와 상호 작용하기가 매우 쉽습니다. 예를 들어 `curl`과 `jq`를 사용하여 NetBox에서 IP 주소를 요청하고 JSON을 출력할 수 있습니다. 다음 명령은 기본 키로 식별된 특정 IP 주소에 대한 정보를 HTTP `GET` 요청으로 가져오고, `jq`를 사용하여 반환된 원시 JSON 데이터를 더 사람 친화적인 형식으로 표시합니다. (`jq`를 통한 출력 파이핑은 필수는 아니지만 읽기가 훨씬 쉬워집니다.)

```no-highlight
curl -s http://netbox/api/ipam/ip-addresses/2954/ | jq '.'
```

```json
{
  "id": 2954,
  "url": "http://netbox/api/ipam/ip-addresses/2954/",
  "family": {
    "value": 4,
    "label": "IPv4"
  },
  "address": "192.168.0.42/26",
  "vrf": null,
  "tenant": null,
  "status": {
    "value": "active",
    "label": "Active"
  },
  "role": null,
  "assigned_object_type": "dcim.interface",
  "assigned_object_id": 114771,
  "assigned_object": {
    "id": 114771,
    "url": "http://netbox/api/dcim/interfaces/114771/",
    "device": {
      "id": 2230,
      "url": "http://netbox/api/dcim/devices/2230/",
      "name": "router1",
      "display_name": "router1"
    },
    "name": "et-0/1/2",
    "cable": null,
    "connection_status": null
  },
  "nat_inside": null,
  "nat_outside": null,
  "dns_name": "",
  "description": "Example IP address",
  "tags": [],
  "custom_fields": {},
  "created": "2020-08-04",
  "last_updated": "2020-08-04T14:12:39.666885Z"
}
```

IP 주소의 각 속성은 JSON 객체의 속성으로 표현됩니다. 필드는 위의 `assigned_object` 필드처럼 자체 중첩 객체를 포함할 수 있습니다. 모든 객체에는 데이터베이스에서 고유하게 식별하는 `id`라는 기본 키가 포함됩니다.

## 대화형 문서

실행 중인 NetBox 인스턴스의 `/api/schema/swagger-ui/`에서 모든 REST API 엔드포인트에 대한 포괄적인 대화형 문서를 사용할 수 있습니다. 이 인터페이스는 특정 엔드포인트와 요청 유형을 연구하고 실험하기 위한 편리한 샌드박스를 제공합니다. API 자체도 루트인 `/api/`로 이동하여 웹 브라우저에서 탐색할 수 있습니다.

## 엔드포인트 계층 구조

NetBox의 전체 REST API는 `https://<hostname>/api/`의 API 루트 아래에 있습니다. URL 구조는 루트 수준에서 애플리케이션별로 나뉩니다: circuits, DCIM, extras, IPAM, plugins, tenancy, users, virtualization. 각 애플리케이션 내에는 각 모델에 대한 별도의 경로가 있습니다. 예를 들어 제공업체와 회선 객체는 "circuits" 애플리케이션 아래에 있습니다:

* `/api/circuits/providers/`
* `/api/circuits/circuits/`

마찬가지로 사이트, 랙, 장비 객체는 "DCIM" 애플리케이션 아래에 있습니다:

* `/api/dcim/sites/`
* `/api/dcim/racks/`
* `/api/dcim/devices/`

사용 가능한 엔드포인트의 전체 계층 구조는 웹 브라우저에서 API 루트로 이동하여 볼 수 있습니다.

각 모델에는 일반적으로 목록 뷰와 상세 뷰 두 가지 뷰가 연결됩니다. 목록 뷰는 여러 객체 목록을 검색하고 새 객체를 생성하는 데 사용됩니다. 상세 뷰는 단일 기존 객체를 검색, 업데이트 또는 삭제하는 데 사용됩니다. 모든 객체는 숫자 기본 키(`id`)로 참조됩니다.

* `/api/dcim/devices/` - 기존 장비 나열 또는 새 장비 생성
* `/api/dcim/devices/123/` - ID 123인 장비 검색, 업데이트 또는 삭제

객체 목록은 쿼리 매개변수 세트를 사용하여 필터링하고 정렬할 수 있습니다. 예를 들어 ID 123인 장비에 속한 모든 인터페이스를 찾으려면:

```
GET /api/dcim/interfaces/?device_id=123
```

선택적 `ordering` 매개변수를 사용하여 결과 정렬 방법을 정의할 수 있습니다. 이전 예제를 기반으로 ID 123인 장비의 모든 인터페이스를 생성 역순(최신에서 가장 오래된 순)으로 정렬하려면:

```
GET /api/dcim/interfaces/?device_id=123&ordering=-created
```

필터링, 정렬 및 조회 표현식과 관련된 자세한 내용은 [필터링 문서](../reference/filtering.md)를 참조하세요.

## 직렬화

REST API는 일반적으로 객체를 전체 또는 간략 두 가지 방법 중 하나로 표현합니다. 기본 직렬화기는 객체의 전체 뷰를 표시하는 데 사용됩니다. 여기에는 모델을 구성하는 모든 데이터베이스 테이블 필드가 포함되며 추가 메타데이터를 포함할 수 있습니다. 기본 직렬화기는 부모 객체와의 관계를 포함하지만 자식 객체는 포함하지 **않습니다**. 예를 들어 `VLANSerializer`는 부모 VLANGroup(있는 경우)의 중첩 표현을 포함하지만 할당된 프리픽스는 포함하지 않습니다. 직렬화기는 관련 객체의 최소 "간략" 표현을 사용하며, 객체를 식별하는 데 필요한 속성만 포함합니다.

```json
{
    "id": 1048,
    "site": {
        "id": 7,
        "url": "http://netbox/api/dcim/sites/7/",
        "name": "Corporate HQ",
        "slug": "corporate-hq"
    },
    "group": {
        "id": 4,
        "url": "http://netbox/api/ipam/vlan-groups/4/",
        "name": "Production",
        "slug": "production"
    },
    "vid": 101,
    "name": "Users-Floor1",
    "tenant": null,
    "status": {
        "value": 1,
        "label": "Active"
    },
    "role": {
        "id": 9,
        "url": "http://netbox/api/ipam/roles/9/",
        "name": "User Access",
        "slug": "user-access"
    },
    "description": "",
    "display_name": "101 (Users-Floor1)",
    "custom_fields": {}
}
```

### 관련 객체

관련 객체(예: `ForeignKey` 필드)는 중첩된 간략 표현을 사용하여 포함됩니다. 이는 객체의 최소 표현으로 직접 URL과 사용자에게 객체를 표시하기에 충분한 정보만 포함합니다. 쓰기 API 작업(`POST`, `PUT`, `PATCH`)을 수행할 때 관련 객체는 숫자 ID(기본 키) 또는 원하는 객체를 반환하기에 충분히 고유한 속성 세트로 지정할 수 있습니다.

예를 들어 새 장비를 생성할 때 랙은 NetBox ID(PK)로 지정할 수 있습니다:

```json
{
    "name": "MyNewDevice",
    "rack": 123,
    ...
}
```

또는 랙을 고유하게 식별하는 속성 세트로:

```json
{
    "name": "MyNewDevice",
    "rack": {
        "site": {
            "name": "Equinix DC6"
        },
        "name": "R204"
    },
    ...
}
```

제공된 매개변수가 정확히 하나의 객체를 반환하지 않으면 유효성 검사 오류가 발생합니다.

### 제네릭 관계

NetBox 내 일부 객체에는 여러 유형의 객체를 참조할 수 있는 속성이 있으며, 이를 _제네릭 관계_라고 합니다. 예를 들어 IP 주소는 장비 인터페이스 _또는_ 가상 머신 인터페이스에 할당할 수 있습니다. REST API를 통해 이 할당을 수행할 때 두 가지 속성을 지정해야 합니다:

* `assigned_object_type` - `<app>.<model>`로 정의된 할당된 객체의 콘텐츠 타입
* `assigned_object_id` - 할당된 객체의 고유 숫자 ID

이 값들은 함께 NetBox에서 고유한 객체를 식별합니다. 할당된 객체(있는 경우)는 IP 주소 모델의 `assigned_object` 속성으로 표시됩니다.

```no-highlight
curl -X POST \
-H "Authorization: Token $TOKEN" \
-H "Content-Type: application/json" \
-H "Accept: application/json; indent=4" \
http://netbox/api/ipam/ip-addresses/ \
--data '{
    "address": "192.0.2.1/24",
    "assigned_object_type": "dcim.interface",
    "assigned_object_id": 69023
}'
```

```json
{
    "id": 56296,
    "url": "http://netbox/api/ipam/ip-addresses/56296/",
    "assigned_object_type": "dcim.interface",
    "assigned_object_id": 69000,
    "assigned_object": {
        "id": 69000,
        "url": "http://netbox/api/dcim/interfaces/69023/",
        "device": {
            "id": 2174,
            "url": "http://netbox/api/dcim/devices/2174/",
            "name": "device105",
            "display_name": "device105"
        },
        "name": "ge-0/0/0",
        "cable": null,
        "connection_status": null
    },
    ...
}
```

이 IP 주소를 대신 가상 머신 인터페이스에 할당하려면 `assigned_object_type`을 `virtualization.vminterface`로 설정하고 객체 ID를 적절히 업데이트했을 것입니다.

### 간략 형식

대부분의 API 엔드포인트는 선택적 "간략" 형식을 지원하며, 응답에서 각 객체의 최소 표현만 반환합니다. 이는 폼의 드롭다운 목록을 채울 때와 같이 관련 데이터 없이 사용 가능한 객체 목록만 필요할 때 유용합니다. 예를 들어 프리픽스의 기본(전체) 형식은 다음과 같습니다:

```no-highlight
GET /api/ipam/prefixes/13980/
```

```json
{
    "id": 13980,
    "url": "http://netbox/api/ipam/prefixes/13980/",
    "display_url": "http://netbox/api/ipam/prefixes/13980/",
    "display": "192.0.2.0/24",
    "family": {
        "value": 4,
        "label": "IPv4"
    },
    "prefix": "192.0.2.0/24",
    "vrf": null,
    "scope_type": "dcim.site",
    "scope_id": 3,
    "scope": {
        "id": 3,
        "url": "http://netbox/api/dcim/sites/3/",
        "display": "Site 23A",
        "name": "Site 23A",
        "slug": "site-23a",
        "description": ""
    },
    "tenant": null,
    "vlan": null,
    "status": {
        "value": "container",
        "label": "Container"
    },
    "role": {
        "id": 17,
        "url": "http://netbox/api/ipam/roles/17/",
        "name": "Staging",
        "slug": "staging"
    },
    "is_pool": false,
    "mark_utilized": false,
    "description": "Example prefix",
    "comments": "",
    "tags": [],
    "custom_fields": {},
    "created": "2025-03-01T20:01:23.458302Z",
    "last_updated": "2025-03-01T20:02:46.173540Z",
    "children": 0,
    "_depth": 0
}
```

간략 형식은 훨씬 더 간결합니다:

```no-highlight
GET /api/ipam/prefixes/13980/?brief=1
```

```json
{
    "id": 13980,
    "url": "http://netbox/api/ipam/prefixes/13980/",
    "display": "192.0.2.0/24",
    "family": {
        "value": 4,
        "label": "IPv4"
    },
    "prefix": "192.0.2.0/24",
    "description": "Example prefix",
    "_depth": 0
}
```

간략 형식은 목록과 개별 객체 모두에 지원됩니다.

### 구성 컨텍스트 제외

REST API를 통해 장비와 가상 머신을 검색할 때 각각에는 기본적으로 렌더링된 [구성 컨텍스트 데이터](../features/context-data.md)가 포함됩니다. 대량의 컨텍스트 데이터가 있는 사용자는 특히 매우 큰 페이지 크기에서 여러 객체를 반환할 때 최적이 아닌 성능을 관찰할 가능성이 높습니다. 이를 해결하기 위해 요청에 쿼리 매개변수 `?exclude=config_context`를 첨부하여 응답 데이터에서 컨텍스트 데이터를 제외할 수 있습니다. 이 매개변수는 목록 및 상세 뷰 모두에서 작동합니다.

## 페이지네이션

많은 객체 목록을 포함하는 API 응답은 효율성을 위해 페이지네이션됩니다. 목록 엔드포인트에서 반환된 루트 JSON 객체에는 다음 속성이 포함됩니다:

* `count`: 쿼리와 일치하는 모든 객체의 총 수
* `next`: 다음 결과 페이지에 대한 하이퍼링크(해당되는 경우)
* `previous`: 이전 결과 페이지에 대한 하이퍼링크(해당되는 경우)
* `results`: 현재 페이지의 객체 목록

다음은 페이지네이션된 응답의 예입니다:

```
HTTP 200 OK
Allow: GET, POST, OPTIONS
Content-Type: application/json
Vary: Accept

{
    "count": 2861,
    "next": "http://netbox/api/dcim/devices/?limit=50&offset=50",
    "previous": null,
    "results": [
        {
            "id": 231,
            "name": "Device1",
            ...
        },
        {
            "id": 232,
            "name": "Device2",
            ...
        },
        ...
    ]
}
```

기본 페이지는 [`PAGINATE_COUNT`](../configuration/default-values.md#paginate_count) 구성 매개변수에 의해 결정되며 기본값은 50입니다. 그러나 원하는 `offset` 및 `limit` 쿼리 매개변수를 지정하여 요청별로 재정의할 수 있습니다. 예를 들어 한 번에 100개의 장비를 검색하려면 다음을 요청합니다:

```
http://netbox/api/dcim/devices/?limit=100
```

응답은 1번부터 100번까지의 장비를 반환합니다. 응답의 `next` 속성에 제공된 URL은 101번부터 200번까지의 장비를 반환합니다:

```json
{
    "count": 2861,
    "next": "http://netbox/api/dcim/devices/?limit=100&offset=100",
    "previous": null,
    "results": [...]
}
```

반환할 수 있는 최대 객체 수는 [`MAX_PAGE_SIZE`](../configuration/miscellaneous.md#max_page_size) 구성 매개변수에 의해 제한되며 기본값은 1000입니다. 이를 `0` 또는 `None`으로 설정하면 최대 제한이 제거됩니다. 그러면 API 사용자가 `?limit=0`을 전달하여 단일 요청으로 _모든_ 일치하는 객체를 검색할 수 있습니다.

!!! warning
    페이지 크기 제한을 비활성화하면 하나의 API 요청이 데이터베이스에서 전체 테이블을 효과적으로 검색할 수 있으므로 매우 리소스 집약적인 요청이 발생할 가능성이 있습니다.

## 객체와 상호 작용

### 여러 객체 검색

NetBox에서 객체 목록을 쿼리하려면 모델의 _목록_ 엔드포인트에 `GET` 요청을 수행합니다. 객체는 응답 객체의 `results` 매개변수 아래에 나열됩니다.

```no-highlight
curl -s -X GET http://netbox/api/ipam/ip-addresses/ | jq '.'
```

```json
{
  "count": 42031,
  "next": "http://netbox/api/ipam/ip-addresses/?limit=50&offset=50",
  "previous": null,
  "results": [
    {
      "id": 5618,
      "address": "192.0.2.1/24",
      ...
    },
    {
      "id": 5619,
      "address": "192.0.2.2/24",
      ...
    },
    {
      "id": 5620,
      "address": "192.0.2.3/24",
      ...
    },
    ...
  ]
}
```

### 단일 객체 검색

NetBox에서 단일 객체를 쿼리하려면 고유 숫자 ID를 지정하여 모델의 _상세_ 엔드포인트에 `GET` 요청을 수행합니다.

!!! note
    후행 슬래시가 필요합니다. 이를 생략하면 302 리디렉션이 반환됩니다.

```no-highlight
curl -s -X GET http://netbox/api/ipam/ip-addresses/5618/ | jq '.'
```

```json
{
  "id": 5618,
  "address": "192.0.2.1/24",
  ...
}
```

### 새 객체 생성

새 객체를 생성하려면 생성할 객체와 관련된 JSON 데이터를 사용하여 모델의 _목록_ 엔드포인트에 `POST` 요청을 수행합니다. 모든 쓰기 작업에는 REST API 토큰이 필요합니다. 자세한 내용은 [인증 섹션](#api-인증)을 참조하세요. 또한 `Content-Type` HTTP 헤더를 `application/json`으로 설정해야 합니다.

```no-highlight
curl -s -X POST \
-H "Authorization: Token $TOKEN" \
-H "Content-Type: application/json" \
http://netbox/api/ipam/prefixes/ \
--data '{"prefix": "192.0.2.0/24", "scope_type": "dcim.site", "scope_id": 6}' | jq '.'
```

```json
{
  "id": 18691,
  "url": "http://netbox/api/ipam/prefixes/18691/",
  "display_url": "http://netbox/api/ipam/prefixes/18691/",
  "display": "192.0.2.0/24",
  "family": {
    "value": 4,
    "label": "IPv4"
  },
  "prefix": "192.0.2.0/24",
  "vrf": null,
  "scope_type": "dcim.site",
  "scope_id": 6,
  "scope": {
    "id": 6,
    "url": "http://netbox/api/dcim/sites/6/",
    "display": "US-East 4",
    "name": "US-East 4",
    "slug": "us-east-4",
    "description": ""
  },
  "tenant": null,
  "vlan": null,
  "status": {
    "value": "active",
    "label": "Active"
  },
  "role": null,
  "is_pool": false,
  "mark_utilized": false,
  "description": "",
  "comments": "",
  "tags": [],
  "custom_fields": {},
  "created": "2025-04-29T15:44:47.597092Z",
  "last_updated": "2025-04-29T15:44:47.597092Z",
  "children": 0,
  "_depth": 0
}
```

### 여러 객체 생성

단일 요청을 사용하여 모델의 여러 인스턴스를 생성하려면 생성할 각 인스턴스를 나타내는 JSON 객체 목록을 사용하여 모델의 _목록_ 엔드포인트에 `POST` 요청을 수행합니다. 성공하면 응답에 새로 생성된 인스턴스 목록이 포함됩니다. 아래 예제는 세 개의 새 사이트 생성을 보여줍니다.

```no-highlight
curl -X POST -H "Authorization: Token $TOKEN" \
-H "Content-Type: application/json" \
-H "Accept: application/json; indent=4" \
http://netbox/api/dcim/sites/ \
--data '[
{"name": "Site 1", "slug": "site-1", "region": {"name": "United States"}},
{"name": "Site 2", "slug": "site-2", "region": {"name": "United States"}},
{"name": "Site 3", "slug": "site-3", "region": {"name": "United States"}}
]'
```

```json
[
    {
        "id": 21,
        "url": "http://netbox/api/dcim/sites/21/",
        "name": "Site 1",
        ...
    },
    {
        "id": 22,
        "url": "http://netbox/api/dcim/sites/22/",
        "name": "Site 2",
        ...
    },
    {
        "id": 23,
        "url": "http://netbox/api/dcim/sites/23/",
        "name": "Site 3",
        ...
    }
]
```

### 객체 업데이트

이미 생성된 객체를 수정하려면 고유 숫자 ID를 지정하여 모델의 _상세_ 엔드포인트에 `PATCH` 요청을 수행합니다. 객체에서 업데이트하려는 모든 데이터를 포함합니다. 객체 생성과 마찬가지로 `Authorization` 및 `Content-Type` 헤더도 지정해야 합니다.

```no-highlight
curl -s -X PATCH \
-H "Authorization: Token $TOKEN" \
-H "Content-Type: application/json" \
http://netbox/api/ipam/prefixes/18691/ \
--data '{"status": "reserved"}' | jq '.'
```

```json
{
  "id": 18691,
  "url": "http://netbox/api/ipam/prefixes/18691/",
  "display_url": "http://netbox/api/ipam/prefixes/18691/",
  "display": "192.0.2.0/24",
  "family": {
    "value": 4,
    "label": "IPv4"
  },
  "prefix": "192.0.2.0/24",
  "vrf": null,
  "scope_type": "dcim.site",
  "scope_id": 6,
  "scope": {
    "id": 6,
    "url": "http://netbox/api/dcim/sites/6/",
    "display": "US-East 4",
    "name": "US-East 4",
    "slug": "us-east-4",
    "description": ""
  },
  "tenant": null,
  "vlan": null,
  "status": {
    "value": "reserved",
    "label": "Reserved"
  },
  "role": null,
  "is_pool": false,
  "mark_utilized": false,
  "description": "",
  "comments": "",
  "tags": [],
  "custom_fields": {},
  "created": "2025-04-29T15:44:47.597092Z",
  "last_updated": "2025-04-29T15:49:40.689109Z",
  "children": 0,
  "_depth": 0
}
```

!!! note "PUT 대 PATCH"
    NetBox REST API는 기존 객체를 수정하기 위해 `PUT` 또는 `PATCH` 사용을 모두 지원합니다. 차이점은 `PUT` 요청은 수정 중인 객체의 _전체_ 표현을 지정해야 하고, `PATCH` 요청은 업데이트 중인 속성만 포함하면 된다는 것입니다. 대부분의 목적에서 `PATCH` 사용을 권장합니다.

### 여러 객체 업데이트

삭제할 각 객체의 숫자 ID와 업데이트할 속성을 지정하는 딕셔너리 목록과 함께 모델의 목록 엔드포인트에 `PUT` 또는 `PATCH` 요청을 발행하여 여러 객체를 동시에 업데이트할 수 있습니다. 예를 들어 ID 10과 11인 사이트를 "active" 상태로 업데이트하려면 다음 요청을 발행합니다:

```no-highlight
curl -s -X PATCH \
-H "Authorization: Token $TOKEN" \
-H "Content-Type: application/json" \
http://netbox/api/dcim/sites/ \
--data '[{"id": 10, "status": "active"}, {"id": 11, "status": "active"}]'
```

속성이 객체 간에 동일할 필요는 없습니다. 예를 들어 동일한 요청에서 한 사이트의 상태와 다른 사이트의 이름을 함께 업데이트할 수 있습니다.

!!! note
    객체의 대량 업데이트는 전부 아니면 전무 작업입니다. 즉, NetBox가 지정된 객체 중 하나라도 성공적으로 업데이트하지 못하면(예: 유효성 검사 오류로 인해) 전체 작업이 중단되고 어떤 객체도 업데이트되지 않습니다.

### 객체 삭제

NetBox에서 객체를 삭제하려면 고유 숫자 ID를 지정하여 모델의 _상세_ 엔드포인트에 `DELETE` 요청을 수행합니다. 인증 토큰을 지정하기 위해 `Authorization` 헤더를 포함해야 하지만 이 유형의 요청은 본문에 데이터를 전달하는 것을 지원하지 않습니다.

```no-highlight
curl -s -X DELETE \
-H "Authorization: Token $TOKEN" \
http://netbox/api/ipam/prefixes/18691/
```

`DELETE` 요청은 데이터를 반환하지 않습니다. 성공하면 API는 204 (No Content) 응답을 반환합니다.

!!! note
    HTTP 응답 코드를 검사하기 위해 verbose(`-v`) 플래그와 함께 `curl`을 실행할 수 있습니다.

### 여러 객체 삭제

NetBox는 삭제할 각 객체의 숫자 ID를 지정하는 딕셔너리 목록과 함께 모델의 목록 엔드포인트에 `DELETE` 요청을 발행하여 동일한 유형의 여러 객체를 동시에 삭제하는 것을 지원합니다. 예를 들어 ID 10, 11, 12인 사이트를 삭제하려면 다음 요청을 발행합니다:

```no-highlight
curl -s -X DELETE \
-H "Authorization: Token $TOKEN" \
-H "Content-Type: application/json" \
http://netbox/api/dcim/sites/ \
--data '[{"id": 10}, {"id": 11}, {"id": 12}]'
```

!!! note
    객체의 대량 삭제는 전부 아니면 전무 작업입니다. 즉, NetBox가 지정된 객체 중 하나라도 삭제하지 못하면(예: 관련 객체의 종속성으로 인해) 전체 작업이 중단되고 어떤 객체도 삭제되지 않습니다.

## 변경 로그 메시지

!!! info "이 기능은 NetBox v4.4에서 도입되었습니다."

NetBox의 대부분의 객체는 [변경 로깅](../features/change-logging.md)을 지원하며, 객체가 생성, 수정 또는 삭제될 때마다 상세 기록을 생성합니다. NetBox v4.4부터 사용자는 변경 기록에 메시지도 첨부할 수 있습니다. 이는 객체 표현에 `changelog_message` 필드를 포함하여 REST API를 통해 수행됩니다.

예를 들어 다음 API 요청은 새 사이트를 생성하고 결과 변경 로그 항목에 메시지를 기록합니다:

```no-highlight
curl -s -X POST \
-H "Authorization: Token $TOKEN" \
-H "Content-Type: application/json" \
http://netbox/api/dcim/sites/ \
--data '{
    "name": "Site A",
    "slug": "site-a",
    "changelog_message": "Adding a site for ticket #4137"
}'
```

이 접근 방식은 개별적으로 또는 대량으로 객체를 생성, 수정 또는 삭제할 때 작동합니다.

## 파일 업로드

JSON은 바이너리 데이터 포함을 지원하지 않으므로 JSON 형식의 API 요청을 사용하여 파일을 업로드할 수 없습니다. 대신 폼 데이터 인코딩을 사용하여 로컬 파일을 첨부할 수 있습니다.

예를 들어 아래 표시된 `curl` 명령을 사용하여 이미지 첨부 파일을 업로드할 수 있습니다. `@`는 업로드할 디스크의 로컬 파일을 나타냅니다.

```no-highlight
curl -X POST \
-H "Authorization: Token $TOKEN" \
-H "Accept: application/json; indent=4" \
-F "object_type=dcim.site" \
-F "object_id=2" \
-F "name=attachment1.png" \
-F "image=@local_file.png" \
http://netbox/api/extras/image-attachments/
```

## 인증

NetBox REST API는 주로 토큰 기반 인증을 사용합니다. 편의를 위해 브라우저 API를 탐색할 때 쿠키 기반 인증도 사용할 수 있습니다.

### 토큰

토큰은 NetBox 사용자 계정에 매핑된 고유 식별자입니다. 각 사용자는 REST API 요청을 수행할 때 인증에 사용할 수 있는 하나 이상의 토큰을 가질 수 있습니다. 토큰을 생성하려면 사용자 프로필 아래의 API 토큰 페이지로 이동합니다.

기본적으로 모든 사용자는 UI의 사용자 제어판 또는 REST API를 통해 자체 REST API 토큰을 생성하고 관리할 수 있습니다. 이 기능은 [`DEFAULT_PERMISSIONS`](../configuration/security.md#default_permissions) 구성 매개변수를 재정의하여 비활성화할 수 있습니다.

각 토큰에는 40개의 16진수 문자로 표시되는 160비트 키가 포함됩니다. 토큰을 생성할 때 일반적으로 키 필드를 비워 두어 무작위 키가 자동으로 생성되도록 합니다. 그러나 NetBox에서는 이전에 삭제된 토큰을 다시 작동하도록 복원해야 하는 경우 키를 지정할 수 있습니다.

또한 토큰이 특정 시간에 만료되도록 설정할 수 있습니다. 이는 외부 클라이언트에 NetBox에 대한 임시 액세스를 부여해야 하는 경우 유용할 수 있습니다.

!!! info "토큰 검색 제한"
    이전에 생성된 API 토큰의 키 값을 검색하는 기능은 [`ALLOW_TOKEN_RETRIEVAL`](../configuration/security.md#allow_token_retrieval) 구성 매개변수를 비활성화하여 제한할 수 있습니다.

### 쓰기 작업 제한

기본적으로 토큰은 사용자가 웹 UI를 통해 수행할 수 있는 모든 작업을 API를 통해 수행하는 데 사용할 수 있습니다. "쓰기 사용" 옵션을 선택 해제하면 토큰으로 수행되는 API 요청이 읽기 작업(예: GET)으로만 제한됩니다.

#### 클라이언트 IP 제한

각 API 토큰은 선택적으로 클라이언트 IP 주소로 제한할 수 있습니다. 토큰에 대해 하나 이상의 허용된 IP 프리픽스/주소가 정의되면 정의된 범위 외부의 IP 주소에서 연결하는 클라이언트에 대해 인증이 실패합니다. 이를 통해 토큰 사용을 특정 클라이언트로 제한할 수 있습니다. (기본적으로 모든 클라이언트 IP 주소가 허용됩니다.)

#### 다른 사용자를 위한 토큰 생성

REST API를 통해 다른 사용자를 위한 인증 토큰을 프로비저닝할 수 있습니다. 이를 위해 요청하는 사용자에게 `users.grant_token` 권한이 할당되어 있어야 합니다. 모든 사용자는 기본적으로 자체 토큰을 생성할 수 있는 고유 권한이 있지만, 다른 사용자를 위한 토큰 생성을 활성화하려면 이 권한이 필요합니다.

!!! warning "주의 필요"
    다른 사용자를 대신하여 토큰을 생성하는 기능을 통해 요청자가 생성된 토큰에 액세스할 수 있습니다. 이 기능은 자동화된 서비스에 의한 토큰 프로비저닝 등을 위한 것이며, 보안 손상을 피하기 위해 극도로 주의하여 사용해야 합니다.

### API 인증

`Authorization` 헤더를 `Token` 문자열과 공백, 사용자 토큰 순으로 설정하여 요청에 인증 토큰을 첨부합니다:

```
$ curl -H "Authorization: Token $TOKEN" \
-H "Accept: application/json; indent=4" \
https://netbox/api/dcim/sites/
{
    "count": 10,
    "next": null,
    "previous": null,
    "results": [...]
}
```

권한 적용에서 면제된 읽기 전용 작업에는 토큰이 필요하지 않습니다([`EXEMPT_VIEW_PERMISSIONS`](../configuration/security.md#exempt_view_permissions) 구성 매개변수 사용). 그러나 토큰이 필요하지만 요청에 없으면 API는 403 (Forbidden) 응답을 반환합니다:

```
$ curl https://netbox/api/dcim/sites/
{
    "detail": "Authentication credentials were not provided."
}
```

토큰이 요청을 인증하는 데 사용되면 마지막 사용이 60초 이상 전에 기록되었거나(또는 기록된 적이 없으면) `last_updated` 시간이 현재 시간으로 업데이트됩니다. 이를 통해 사용자는 최근에 활성화된 토큰을 확인할 수 있습니다.

!!! note
    유지 관리 모드가 활성화되어 있는 동안에는 토큰의 "마지막 사용" 시간이 업데이트되지 않습니다.

### 초기 토큰 프로비저닝

이상적으로 각 사용자는 웹 UI를 통해 자체 API 토큰을 프로비저닝해야 합니다. 그러나 REST API 자체를 통해 사용자가 토큰을 생성해야 하는 시나리오가 발생할 수 있습니다. NetBox는 유효한 사용자 이름과 비밀번호 조합을 사용하여 토큰을 프로비저닝하는 특수 엔드포인트를 제공합니다. (사용하는 인터페이스에 관계없이 사용자에게 API 토큰을 생성할 권한이 있어야 합니다.)

REST API를 통해 토큰을 프로비저닝하려면 `/api/users/tokens/provision/` 엔드포인트에 `POST` 요청을 수행합니다:

```
$ curl -X POST \
-H "Content-Type: application/json" \
-H "Accept: application/json; indent=4" \
https://netbox/api/users/tokens/provision/ \
--data '{
    "username": "hankhill",
    "password": "I<3C3H8"
}'
```

이 요청에서 기존 REST API 토큰을 전달하지 _않습니다_. 제공된 자격 증명이 유효하면 사용자에 대해 새 REST API 토큰이 자동으로 생성됩니다. 키가 자동으로 생성되고 쓰기 기능이 활성화됩니다.

```json
{
    "id": 6,
    "url": "https://netbox/api/users/tokens/6/",
    "display_url": "https://netbox/api/users/tokens/6/",
    "display": "**********************************3c9cb9",
    "user": {
        "id": 2,
        "url": "https://netbox/api/users/users/2/",
        "display": "hankhill",
        "username": "hankhill"
    },
    "created": "2024-03-11T20:09:13.339367Z",
    "expires": null,
    "last_used": null,
    "key": "9fc9b897abec9ada2da6aec9dbc34596293c9cb9",
    "write_enabled": true,
    "description": "",
    "allowed_ips": []
}
```

## HTTP 헤더

### `API-Version`

이 헤더는 사용 중인 API 버전을 지정합니다. 이는 항상 설치된 NetBox 버전과 일치합니다. 예를 들어 NetBox v3.4.2는 API 버전 `3.4`를 보고합니다.

### `X-Request-ID`

이 헤더는 수신된 API 요청에 할당된 고유 ID를 지정합니다. 요청을 변경 기록과 상관시키는 데 매우 유용할 수 있습니다. 예를 들어 여러 새 객체를 생성한 후 객체 변경 API 엔드포인트에 대해 필터링하여 결과 변경 기록을 검색할 수 있습니다:

```
GET /api/extras/object-changes/?request_id=e39c84bc-f169-4d5f-bc1c-94487a1b18b5
```

요청 ID는 특정 요청에 의해 생성되거나 업데이트된 것을 반환하기 위해 많은 객체를 직접 필터링하는 데도 사용할 수 있습니다:

```
GET /api/dcim/sites/?created_by_request=e39c84bc-f169-4d5f-bc1c-94487a1b18b5
```

!!! note
    이 헤더는 API로 작업할 때 가장 실용적이지만 _모든_ NetBox 응답에 포함됩니다.
