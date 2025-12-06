# 데이터 및 유효성 검사 매개변수

## CUSTOM_VALIDATORS

!!! tip "동적 구성 매개변수"

이것은 사용자 정의 유효성 검사 로직을 적용하기 위해 로컬에서 정의된 [사용자 정의 유효성 검사기](../customization/custom-validation.md)에 대한 모델 매핑입니다. 예제는 다음과 같습니다:

```python
CUSTOM_VALIDATORS = {
    "dcim.site": [
        {
            "name": {
                "min_length": 5,
                "max_length": 30
            }
        },
        "my_plugin.validators.Validator1"
    ],
    "dcim.device": [
        "my_plugin.validators.Validator1"
    ]
}
```

---

## FIELD_CHOICES

모델의 일부 정적 선택 필드는 사용자 정의 값으로 구성할 수 있습니다. 이것은 `FIELD_CHOICES`를 모델 필드를 선택 항목에 매핑하는 딕셔너리로 정의하여 수행됩니다. 목록의 각 선택 항목에는 데이터베이스 값과 사용자 친화적인 레이블이 있어야 하며, 선택적으로 색상을 지정할 수 있습니다. (사용 가능한 색상 목록은 아래에 제공됩니다.)

제공된 선택 항목은 NetBox에서 제공하는 기본 선택 항목을 대체하거나 추가할 수 있습니다. 사용 가능한 선택 항목을 _대체_하려면 점으로 구분된 앱, 모델 및 필드 이름을 지정하세요. 예를 들어, site 모델은 `dcim.Site.status`로 참조됩니다. 사용 가능한 선택 항목을 _확장_하려면 이 문자열 끝에 더하기 기호를 추가하세요(예: `dcim.Site.status+`).

예를 들어, 다음 구성은 기본 사이트 상태 선택 항목을 Foo, Bar, Baz 옵션으로 대체합니다:

```python
FIELD_CHOICES = {
    'dcim.Site.status': (
        ('foo', 'Foo', 'red'),
        ('bar', 'Bar', 'green'),
        ('baz', 'Baz', 'blue'),
    )
}
```

필드 식별자에 더하기 기호를 추가하면 이미 제공된 선택 항목에 이러한 선택 항목을 _추가_합니다:

```python
FIELD_CHOICES = {
    'dcim.Site.status+': (
        ...
    )
}
```

다음 모델 필드는 구성 가능한 선택 항목을 지원합니다:

* `circuits.Circuit.status`
* `dcim.Device.status`
* `dcim.Location.status`
* `dcim.Module.status`
* `dcim.PowerFeed.status`
* `dcim.Rack.status`
* `dcim.Site.status`
* `dcim.VirtualDeviceContext.status`
* `extras.JournalEntry.kind`
* `ipam.IPAddress.status`
* `ipam.IPRange.status`
* `ipam.Prefix.status`
* `ipam.VLAN.status`
* `virtualization.Cluster.status`
* `virtualization.VirtualMachine.status`
* `wireless.WirelessLAN.status`

다음 색상이 지원됩니다:

* `blue`
* `indigo`
* `purple`
* `pink`
* `red`
* `orange`
* `yellow`
* `green`
* `teal`
* `cyan`
* `gray`
* `black`
* `white`

---

## PROTECTION_RULES

!!! tip "동적 구성 매개변수"

이것은 삭제 직전에 객체가 평가되는 [사용자 정의 유효성 검사기](../customization/custom-validation.md)에 대한 모델 매핑입니다. 유효성 검사가 실패하면 객체가 삭제되지 않습니다. 예제는 다음과 같습니다:

```python
PROTECTION_RULES = {
    "dcim.site": [
        {
            "status": {
                "eq": "decommissioning"
            }
        },
        "my_plugin.validators.Validator1",
    ]
}
```
