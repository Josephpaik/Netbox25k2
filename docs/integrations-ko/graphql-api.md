# GraphQL API 개요

NetBox는 REST API를 보완하기 위해 읽기 전용 [GraphQL](https://graphql.org/) API를 제공합니다. 이 API는 [Strawberry Django](https://strawberry.rocks/)로 구동됩니다.

## 쿼리

GraphQL을 사용하면 클라이언트가 응답에 포함할 임의의 중첩 필드 목록을 지정할 수 있습니다. 모든 쿼리는 루트 `/graphql` API 엔드포인트로 수행됩니다. 예를 들어 활성 상태인 각 회선의 회선 ID와 제공업체 이름을 반환하려면 다음과 같은 요청을 발행할 수 있습니다:

```
curl -H "Authorization: Token $TOKEN" \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
http://netbox/graphql/ \
--data '{"query": "query {circuit_list(filters:{status: STATUS_ACTIVE}) {cid provider {name}}}"}'
```

응답에는 JSON으로 형식화된 요청 데이터가 포함됩니다:

```json
{
  "data": {
    "circuits": [
      {
        "cid": "1002840283",
        "provider": {
          "name": "CenturyLink"
        }
      },
      {
        "cid": "1002840457",
        "provider": {
          "name": "CenturyLink"
        }
      }
    ]
  }
}
```

!!! note
    가독성을 높이기 위해 `jq`와 같은 JSON 파서를 통해 반환 데이터를 전달하는 것이 좋습니다.

NetBox는 각 객체 유형에 대해 단수 및 복수 쿼리 필드를 모두 제공합니다:

* `$OBJECT`: 단일 객체를 반환합니다. 객체의 고유 ID를 `(id: 123)`으로 지정해야 합니다.
* `$OBJECT_list`: 선택적으로 주어진 매개변수로 필터링된 객체 목록을 반환합니다.

예를 들어 `device(id:123)`을 쿼리하여 특정 장비(고유 ID로 식별)를 가져오고, `device_list`(선택적 필터 세트 포함)를 쿼리하여 모든 장비를 가져옵니다.

GraphQL 쿼리 구성에 대한 자세한 내용은 [GraphQL 쿼리 문서](https://graphql.org/learn/queries/)를 참조하세요. 필터링 및 조회 구문은 [Strawberry Django 문서](https://strawberry.rocks/docs/django/guide/filters)를 참조하세요.

## 필터링

!!! note "NetBox v4.3에서 변경됨"
    GraphQL API의 필터링 구문은 NetBox v4.3에서 상당히 변경되었습니다.

필터는 쿼리 이름 바로 뒤에 괄호 안에 키-값 쌍으로 지정할 수 있습니다. 예를 들어 다음은 활성 사이트만 반환합니다:

```
query {
  site_list(
    filters: {
      status: STATUS_ACTIVE
    }
  ) {
    name
  }
}
```

필터는 `OR` 및 `NOT`과 같은 논리 연산자와 결합할 수 있습니다. 예를 들어 다음은 계획됨 _또는_ Foo라는 테넌트에 할당된 모든 사이트를 반환합니다:

```
query {
  site_list(
    filters: {
      status: STATUS_PLANNED,
      OR: {
        tenant: {
          name: {
            exact: "Foo"
          }
        }
      }
    }
  ) {
    name
  }
}
```

필터링은 관련 객체에도 적용할 수 있습니다. 예를 들어 다음 쿼리는 각 장비에 대해 활성화된 인터페이스만 반환합니다:

```
query {
  device_list {
    id
    name
    interfaces(filters: {enabled: true}) {
      name
    }
  }
}
```

## 여러 반환 유형

특정 쿼리는 여러 유형의 객체를 반환할 수 있습니다. 예를 들어 케이블 종단은 회선 종단, 콘솔 포트 및 기타 여러 가지를 반환할 수 있습니다. 이러한 쿼리는 아래와 같이 [인라인 프래그먼트](https://graphql.org/learn/schema/#union-types)를 사용하여 쿼리할 수 있습니다:

```
{
    cable_list {
      id
      a_terminations {
        ... on CircuitTerminationType {
          id
          class_type
        }
        ... on ConsolePortType {
          id
          class_type
        }
        ... on ConsoleServerPortType {
          id
          class_type
        }
      }
    }
}
```

"class_type" 필드는 반환된 데이터를 볼 때 또는 필터링할 때 어떤 유형의 객체인지 구별하는 쉬운 방법입니다. 클래스 이름(예: "CircuitTermination" 또는 "ConsoleServerPort")을 포함합니다.

## 페이지네이션

쿼리에서 페이지네이션을 지정하고 쿼리에 오프셋과 선택적으로 제한을 제공하여 쿼리를 페이지네이션할 수 있습니다. 제한이 주어지지 않으면 기본값 100이 사용됩니다. 쿼리에서 요청하지 않는 한 쿼리는 페이지네이션되지 않습니다. 페이지네이션된 쿼리 예제는 다음과 같습니다:

```
query {
  device_list(pagination: { offset: 0, limit: 20 }) {
    id
  }
}
```

## 인증

NetBox의 GraphQL API는 REST API와 동일한 API 인증 토큰을 사용합니다. 인증 토큰은 다음 형식으로 `Authorization` HTTP 헤더를 첨부하여 요청에 포함됩니다:

```
Authorization: Token $TOKEN
```

## GraphQL API 비활성화

필요하지 않은 경우 [`GRAPHQL_ENABLED`](../configuration/graphql-api.md#graphql_enabled) 구성 매개변수를 False로 설정하고 NetBox를 다시 시작하여 GraphQL API를 비활성화할 수 있습니다.
