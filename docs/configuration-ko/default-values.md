# 기본값 매개변수

## DEFAULT_DASHBOARD

이 매개변수는 사용자의 기본 대시보드의 콘텐츠와 레이아웃을 제어합니다. 대시보드가 생성되면 사용자는 위젯을 추가, 제거 및 재구성하여 원하는 대로 자유롭게 사용자 정의할 수 있습니다.

이 매개변수는 각각 개별 대시보드 위젯과 그 구성을 나타내는 딕셔너리의 반복 가능 객체를 지정해야 합니다. 다음 위젯 속성이 지원됩니다:

* `widget`: Python 클래스에 대한 점으로 구분된 경로(필수)
* `width`: 기본 위젯 너비(1에서 12 사이, 포함)
* `height`: 행 단위의 기본 위젯 높이
* `title`: 위젯 제목
* `color`: 이름으로 지정된 위젯 제목 표시줄의 색상
* `config`: 위젯 구성 매개변수의 딕셔너리 매핑

간단한 예제 구성이 아래에 제공됩니다.

```python
DEFAULT_DASHBOARD = [
    {
        'widget': 'extras.ObjectCountsWidget',
        'width': 4,
        'height': 3,
        'title': 'Organization',
        'config': {
            'models': [
                'dcim.site',
                'tenancy.tenant',
                'tenancy.contact',
            ]
        }
    },
    {
        'widget': 'extras.ObjectCountsWidget',
        'width': 4,
        'height': 3,
        'title': 'IPAM',
        'color': 'blue',
        'config': {
            'models': [
                'ipam.prefix',
                'ipam.iprange',
                'ipam.ipaddress',
            ]
        }
    },
]
```

## DEFAULT_USER_PREFERENCES

!!! tip "동적 구성 매개변수"

새로 생성된 사용자 계정에 대해 설정할 기본 기본 설정을 정의하는 딕셔너리입니다. 예를 들어, 모든 사용자의 기본 페이지 크기를 100으로 설정하려면 다음을 정의합니다:

```python
DEFAULT_USER_PREFERENCES = {
    "pagination": {
        "per_page": 100
    }
}
```

사용 가능한 기본 설정의 전체 목록을 보려면 NetBox에 로그인하고 `/user/preferences/`로 이동하세요. 기본 설정 이름의 마침표는 JSON 데이터에서 중첩 수준을 나타냅니다. 위의 예는 `pagination.per_page`에 매핑됩니다.

참조: 저장된 테이블 열 또는 정렬로 인한 오류를 해결하기 위한 [테이블 기본 설정 지우기](../features/user-preferences.md#clearing-table-preferences).

---

## PAGINATE_COUNT

!!! tip "동적 구성 매개변수"

기본값: `50`

각 객체 목록 내에서 페이지당 표시할 기본 최대 객체 수입니다.

---

## POWERFEED_DEFAULT_AMPERAGE

!!! tip "동적 구성 매개변수"

기본값: `15`

새 전원 피드를 생성할 때 `amperage` 필드의 기본값입니다.

---

## POWERFEED_DEFAULT_MAX_UTILIZATION

!!! tip "동적 구성 매개변수"

기본값: `80`

새 전원 피드를 생성할 때 `max_utilization` 필드의 기본값(백분율)입니다.

---

## POWERFEED_DEFAULT_VOLTAGE

!!! tip "동적 구성 매개변수"

기본값: `120`

새 전원 피드를 생성할 때 `voltage` 필드의 기본값입니다.

---

## RACK_ELEVATION_DEFAULT_UNIT_HEIGHT

!!! tip "동적 구성 매개변수"

기본값: `22`

랙 엘리베이션 내 유닛의 기본 높이(픽셀 단위)입니다. 최상의 결과를 위해 이 값은 `RACK_ELEVATION_DEFAULT_UNIT_WIDTH`의 약 10분의 1이어야 합니다.

---

## RACK_ELEVATION_DEFAULT_UNIT_WIDTH

!!! tip "동적 구성 매개변수"

기본값: `220`

랙 엘리베이션 내 유닛의 기본 너비(픽셀 단위)입니다.
