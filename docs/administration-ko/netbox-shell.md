# NetBox Python 셸

NetBox에는 객체를 직접 쿼리, 생성, 수정 및 삭제할 수 있는 Python 관리 셸이 포함되어 있습니다. 셸에 들어가려면 다음 명령을 실행하세요:

```
./manage.py nbshell
```

이렇게 하면 모든 관련 NetBox 모델이 미리 로드된 [기본 Django 셸](https://docs.djangoproject.com/en/stable/ref/django-admin/#shell)의 약간 사용자 정의된 버전이 시작됩니다. (원하는 경우 `./manage.py shell`을 실행하여 기본 Django 셸도 사용할 수 있습니다.)

```
$ ./manage.py nbshell
### NetBox interactive shell (localhost)
### Python 3.7.10 | Django 3.2.5 | NetBox 3.0
### lsmodels() will show available models. Use help(<model>) for more info.
```

`lsmodels()` 함수는 사용 가능한 모든 NetBox 모델 목록을 출력합니다:

```
>>> lsmodels()
DCIM:
  ConsolePort
  ConsolePortTemplate
  ConsoleServerPort
  ConsoleServerPortTemplate
  Device
  ...
```

!!! warning
    NetBox 셸은 NetBox 데이터 및 기능에 대한 직접적인 접근을 제공하며 유효성 검사가 거의 없습니다. 따라서 권한이 있고 지식이 있는 사용자만 접근할 수 있도록 하는 것이 중요합니다. 전체 백업이 준비되지 않은 상태에서는 관리 셸에서 어떤 작업도 수행하지 마세요.

## 객체 쿼리

객체는 [Django 쿼리셋](https://docs.djangoproject.com/en/stable/topics/db/queries/#retrieving-objects)을 사용하여 데이터베이스에서 검색됩니다. 객체의 기본 쿼리셋은 `<model>.objects.all()` 형식을 취하며, 해당 유형의 모든 객체 목록(잘린 형태)을 반환합니다.

```
>>> Device.objects.all()
<QuerySet [<Device: TestDevice1>, <Device: TestDevice2>, <Device: TestDevice3>,
<Device: TestDevice4>, <Device: TestDevice5>, '...(remaining elements truncated)...']>
```

목록의 모든 객체를 순환하려면 `for` 루프를 사용하세요:

```
>>> for device in Device.objects.all():
...   print(device.name, device.device_type)
...
('TestDevice1', <DeviceType: PacketThingy 9000>)
('TestDevice2', <DeviceType: PacketThingy 9000>)
('TestDevice3', <DeviceType: PacketThingy 9000>)
('TestDevice4', <DeviceType: PacketThingy 9000>)
('TestDevice5', <DeviceType: PacketThingy 9000>)
...
```

쿼리와 일치하는 모든 객체의 개수를 세려면 `all()`을 `count()`로 대체하세요:

```
>>> Device.objects.count()
1274
```

특정 객체를 검색하려면(일반적으로 기본 키 또는 다른 고유 필드로) `get()`을 사용하세요:

```
>>> Site.objects.get(pk=7)
<Site: Test Lab>
```

### 쿼리셋 필터링

대부분의 경우 특정 객체 하위 집합만 검색하려고 할 것입니다. 쿼리셋을 필터링하려면 `all()`을 `filter()`로 대체하고 하나 이상의 키워드 인수를 전달하세요. 예:

```
>>> Device.objects.filter(status="active")
<QuerySet [<Device: TestDevice1>, <Device: TestDevice2>, <Device: TestDevice3>,
<Device: TestDevice8>, <Device: TestDevice9>, '...(remaining elements truncated)...']>
```

쿼리셋은 슬라이싱을 지원하여 특정 범위의 객체를 반환합니다.

```
>>> Device.objects.filter(status="active")[:3]
<QuerySet [<Device: TestDevice1>, <Device: TestDevice2>, <Device: TestDevice3>]>
```

`count()` 메서드를 쿼리셋에 추가하여 전체 목록 대신 객체 개수를 반환할 수 있습니다.

```
>>> Device.objects.filter(status="active").count()
982
```

다른 모델과의 관계는 속성 이름을 이중 밑줄로 연결하여 탐색할 수 있습니다. 예를 들어 다음은 "Pied Piper"라는 테넌트에 할당된 모든 장비를 반환합니다.

```
>>> Device.objects.filter(tenant__name="Pied Piper")
```

이 접근 방식은 여러 수준의 관계에 걸쳐 있을 수 있습니다. 예를 들어 다음은 북미에 있는 장비에 할당된 모든 IP 주소를 반환합니다:

```
>>> IPAddress.objects.filter(interface__device__site__region__slug="north-america")
```

!!! note
    위의 쿼리는 작동하지만 효율적이지 않습니다. 이러한 요청을 최적화하는 방법이 있지만 이 문서의 범위를 벗어납니다. 자세한 내용은 [Django 쿼리셋 메서드 참조](https://docs.djangoproject.com/en/stable/ref/models/querysets/) 문서를 참조하세요.

역방향 관계도 탐색할 수 있습니다. 예를 들어 다음은 "em0"이라는 인터페이스가 있는 모든 장비를 찾습니다:

```
>>> Device.objects.filter(interfaces__name="em0")
```

문자 필드는 `contains` 또는 `icontains` 필드 조회를 사용하여 부분 일치에 대해 필터링할 수 있습니다(후자는 대소문자를 구분하지 않음).

```
>>> Device.objects.filter(name__icontains="testdevice")
```

마찬가지로 숫자 필드는 주어진 값보다 작거나, 크거나, 같은 값으로 필터링할 수 있습니다.

```
>>> VLAN.objects.filter(vid__gt=2000)
```

여러 필터를 결합하여 쿼리셋을 더 세분화할 수 있습니다.

```
>>> VLAN.objects.filter(vid__gt=2000, name__icontains="engineering")
```

필터링된 쿼리셋의 역을 반환하려면 `filter()` 대신 `exclude()`를 사용하세요.

```
>>> Device.objects.count()
4479
>>> Device.objects.filter(status="active").count()
4133
>>> Device.objects.exclude(status="active").count()
346
```

!!! info
    위의 예제는 쿼리셋 필터링에 대한 간략한 소개만 제공합니다. 사용 가능한 필터의 전체 목록은 [Django 쿼리셋 API 문서](https://docs.djangoproject.com/en/stable/ref/models/querysets/)를 참조하세요.

## 객체 생성 및 업데이트

새 객체는 원하는 모델을 인스턴스화하고 모든 필수 속성의 값을 정의한 다음 인스턴스에서 `save()`를 호출하여 생성할 수 있습니다. 예를 들어 숫자 ID, 이름 및 할당된 사이트를 지정하여 새 VLAN을 생성할 수 있습니다:

```
>>> lab1 = Site.objects.get(pk=7)
>>> myvlan = VLAN(vid=123, name='MyNewVLAN', site=lab1)
>>> myvlan.full_clean()
>>> myvlan.save()
```

기존 객체를 수정하려면 검색하고 원하는 필드를 업데이트한 다음 `save()`를 다시 호출합니다.

```
>>> vlan = VLAN.objects.get(pk=1280)
>>> vlan.name
'MyNewVLAN'
>>> vlan.name = 'BetterName'
>>> vlan.full_clean()
>>> vlan.save()
>>> VLAN.objects.get(pk=1280).name
'BetterName'
```

!!! warning
    Django ORM은 여러 객체를 한 번에 생성/편집하는 메서드, 즉 `bulk_create()` 및 `update()`를 제공합니다. 이러한 메서드는 모델의 기본 제공 유효성 검사를 우회하고 신중하게 사용하지 않으면 데이터베이스 손상으로 쉽게 이어질 수 있으므로 대부분의 경우 피하는 것이 좋습니다.

## 객체 삭제

객체를 삭제하려면 해당 인스턴스에서 `delete()`를 호출하면 됩니다. 이 작업의 결과로 삭제된 모든 객체(관련 객체 포함)의 딕셔너리를 반환합니다.

```
>>> vlan
<VLAN: 123 (BetterName)>
>>> vlan.delete()
(1, {'ipam.VLAN': 1})
```

여러 객체를 한 번에 삭제하려면 필터링된 쿼리셋에서 `delete()`를 호출합니다. 삭제하기 _전에_ 항상 선택한 객체의 개수를 확인하는 것이 좋습니다.

```
>>> Device.objects.filter(name__icontains='test').count()
27
>>> Device.objects.filter(name__icontains='test').delete()
(35, {'dcim.DeviceBay': 0, 'dcim.InterfaceConnection': 4,
'extras.ImageAttachment': 0, 'dcim.Device': 27, 'dcim.Interface': 4,
'dcim.ConsolePort': 0, 'dcim.PowerPort': 0})
```

!!! warning
    삭제는 즉시 실행되며 되돌릴 수 없습니다. 인스턴스 또는 쿼리셋에서 `delete()`를 호출하기 전에 항상 객체 삭제의 영향을 신중하게 고려하세요.
