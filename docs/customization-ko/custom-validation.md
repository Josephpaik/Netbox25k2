# 사용자 정의 유효성 검사

NetBox는 데이터 무결성을 보장하기 위해 데이터베이스에 기록되기 전에 모든 객체의 유효성을 검사합니다. 이 유효성 검사에는 적절한 형식 확인 및 관련 객체에 대한 참조가 유효한지 확인하는 것이 포함됩니다. 그러나 자체 규칙으로 이 유효성 검사를 보완할 수 있습니다. 예를 들어, 모든 사이트의 이름이 특정 패턴을 준수하도록 요구할 수 있습니다. 이것은 사용자 정의 유효성 검사 규칙을 사용하여 수행할 수 있습니다.

## 사용자 정의 유효성 검사 규칙

사용자 정의 유효성 검사 규칙은 객체 속성을 해당 속성이 준수해야 하는 규칙 집합에 매핑하는 것으로 표현됩니다. 예:

```json
{
  "name": {
    "min_length": 5,
    "max_length": 30
  }
}
```

이것은 객체의 `name` 속성 길이가 최소 5자 이상이고 30자 이하인지 확인하는 사용자 정의 유효성 검사기를 정의합니다. 이 유효성 검사는 NetBox가 자체 내부 유효성 검사를 수행한 _후에_ 실행됩니다.

### 유효성 검사 유형

`CustomValidator` 클래스는 여러 유효성 검사 유형을 지원합니다:

* `min`: 최소값
* `max`: 최대값
* `min_length`: 최소 문자열 길이
* `max_length`: 최대 문자열 길이
* `regex`: [정규 표현식](https://en.wikipedia.org/wiki/Regular_expression) 적용
* `required`: 값을 지정해야 함
* `prohibited`: 값을 지정하면 _안 됨_
* `eq`: 값이 지정된 값과 같아야 함
* `neq`: 값이 지정된 값과 같으면 _안 됨_

`min` 및 `max` 유형은 숫자 값에 대해 정의해야 하고, `min_length`, `max_length` 및 `regex`는 문자열(텍스트 값)에 적합합니다. `required` 및 `prohibited` 유효성 검사기는 모든 필드에 사용할 수 있으며 `True` 값을 전달해야 합니다.

!!! warning
    이러한 유효성 검사기는 NetBox의 자체 유효성 검사를 보완할 뿐입니다: 재정의하지 않습니다. 예를 들어, 특정 모델 필드가 NetBox에서 필수인 경우 `{'prohibited': True}`로 유효성 검사기를 설정해도 작동하지 않습니다.

### 사용자 정의 유효성 검사 로직

제공된 유효성 검사 유형이 충분하지 않은 경우가 있을 수 있습니다. NetBox는 `validate()` 메서드를 재정의하고 만족스럽지 않은 조건이 감지되면 `fail()`을 호출하여 임의의 유효성 검사 로직을 적용할 수 있는 `CustomValidator` 클래스를 제공합니다. `validate()` 메서드는 인스턴스(저장되는 객체)와 변경을 수행하는 현재 요청을 받아야 합니다.

```python
from extras.validators import CustomValidator

class MyValidator(CustomValidator):

    def validate(self, instance, request):
        if instance.status == 'active' and not instance.description:
            self.fail("Active sites must have a description set!", field='status')
```

`fail()` 메서드는 선택적으로 제공된 오류 메시지와 연결할 필드를 지정할 수 있습니다. 지정하면 오류 메시지가 이 필드와 연결된 것으로 사용자에게 표시됩니다. 생략하면 오류 메시지가 어떤 필드와도 연결되지 않습니다.

## 사용자 정의 유효성 검사기 할당

사용자 정의 유효성 검사기는 [CUSTOM_VALIDATORS](../configuration/data-validation.md#custom_validators) 구성 매개변수 아래에서 특정 NetBox 모델과 연결됩니다. 사용자 정의 유효성 검사 규칙을 정의할 수 있는 세 가지 방법이 있습니다:

1. 일반 JSON 매핑(사용자 정의 로직 없음)
2. 사용자 정의 유효성 검사기 클래스에 대한 점으로 구분된 경로
3. 사용자 정의 유효성 검사기 클래스에 대한 직접 참조

### 일반 데이터

사용자 정의 로직이 필요하지 않은 경우 유효성 검사 규칙을 일반 JSON 호환 객체로 전달하는 것으로 충분합니다. 이 접근 방식은 일반적으로 구성에 가장 높은 이식성을 제공합니다. 예:

```python
CUSTOM_VALIDATORS = {
    "dcim.site": [
        {
            "name": {
                "min_length": 5,
                "max_length": 30,
            }
        }
    ],
    "dcim.device": [
        {
            "platform": {
                "required": True,
            }
        }
    ]
}
```

#### 관련 객체 속성 참조

점으로 구분된 경로를 지정하여 관련 객체의 속성을 참조할 수 있습니다. 예를 들어, 사이트에 할당된 지역의 이름을 참조하려면 `region.name`을 사용합니다:

```python
CUSTOM_VALIDATORS = {
    "dcim.site": [
        {
            "region.name": {
                "neq": "New York"
            }
        }
    ]
}
```

#### 요청 매개변수 유효성 검사

객체 속성의 유효성 검사 외에도 사용자 정의 유효성 검사기는 현재 요청의 매개변수(사용 가능한 경우)와도 일치할 수 있습니다. 예를 들어, 다음 규칙은 "admin"이라는 사용자만 객체를 수정할 수 있도록 허용합니다:

```json
{
  "request.user.username": {
    "eq": "admin"
  }
}
```

!!! tip
    사용자 정의 유효성 검사는 일반적으로 권한을 적용하는 데 사용해서는 안 됩니다. NetBox는 이 목적으로 사용해야 하는 강력한 [객체 기반 권한](../administration/permissions.md) 메커니즘을 제공합니다.

### 클래스에 대한 점으로 구분된 경로

사용자 정의 유효성 검사기 클래스가 필요한 경우 Python 경로(NetBox의 작업 디렉토리 기준)로 참조할 수 있습니다:

```python
CUSTOM_VALIDATORS = {
    'dcim.site': (
        'my_validators.Validator1',
        'my_validators.Validator2',
    ),
    'dcim.device': (
        'my_validators.Validator3',
    )
}
```

### 직접 클래스 참조

이 접근 방식은 인스턴스화되는 각 클래스를 Python 구성 파일 내에서 직접 가져와야 합니다.

```python
from my_validators import Validator1, Validator2, Validator3

CUSTOM_VALIDATORS = {
    'dcim.site': (
        Validator1(),
        Validator2(),
    ),
    'dcim.device': (
        Validator3(),
    )
}
```

!!! note
    단일 유효성 검사기만 정의하더라도 반복 가능 객체로 전달해야 합니다.
