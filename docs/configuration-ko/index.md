# NetBox 구성

## 구성 파일

NetBox의 구성 파일에는 NetBox 작동 방식을 제어하는 모든 중요한 매개변수가 포함되어 있습니다: 데이터베이스 설정, 보안 제어, 사용자 기본 설정 등. 기본 구성은 대부분의 사용 사례에서 즉시 사용할 수 있지만, 설치 중에 **반드시** 정의해야 하는 몇 가지 [필수 매개변수](./required-parameters.md)가 있습니다.

구성 파일은 기본적으로 `$INSTALL_ROOT/netbox/netbox/configuration.py`에서 로드됩니다. 예제 구성은 `configuration_example.py`에 제공되며, 이를 복사하여 기본 구성으로 사용할 수 있습니다. 구성 파일은 반드시 정의되어야 하며, NetBox는 구성 파일 없이 실행되지 않습니다.

!!! info "구성 모듈 사용자 정의"
    `NETBOX_CONFIGURATION` 환경 변수를 설정하여 사용자 정의 구성 모듈을 지정할 수 있습니다. 이는 원하는 Python 모듈에 대한 점으로 구분된 경로여야 합니다. 예를 들어, `settings.py`와 같은 디렉토리에 있는 `my_config.py` 파일은 `netbox.my_config`로 참조됩니다.

    설명을 단순화하기 위해 NetBox 문서에서는 구성 파일을 단순히 `configuration.py`로 지칭합니다.

일부 구성 매개변수는 `configuration.py` 또는 사용자 인터페이스의 관리 섹션에서 정의할 수 있습니다. 구성 파일에 "하드 코딩"된 설정은 UI를 통해 정의된 설정보다 우선합니다.

## 동적 구성 매개변수

일부 구성 매개변수는 주로 NetBox의 관리 인터페이스(Admin > Extras > Configuration Revisions)를 통해 제어됩니다. 해당하는 경우 문서에 표시됩니다. 이러한 설정은 UI를 통한 수정을 방지하기 위해 `configuration.py`에서 재정의할 수도 있습니다. 지원되는 매개변수의 전체 목록은 다음과 같습니다:

* [`ALLOWED_URL_SCHEMES`](./security.md#allowed_url_schemes)
* [`BANNER_BOTTOM`](./miscellaneous.md#banner_bottom)
* [`BANNER_LOGIN`](./miscellaneous.md#banner_login)
* [`BANNER_TOP`](./miscellaneous.md#banner_top)
* [`CHANGELOG_RETENTION`](./miscellaneous.md#changelog_retention)
* [`CUSTOM_VALIDATORS`](./data-validation.md#custom_validators)
* [`DEFAULT_USER_PREFERENCES`](./default-values.md#default_user_preferences)
* [`ENFORCE_GLOBAL_UNIQUE`](./miscellaneous.md#enforce_global_unique)
* [`GRAPHQL_ENABLED`](./graphql-api.md#graphql_enabled)
* [`JOB_RETENTION`](./miscellaneous.md#job_retention)
* [`MAINTENANCE_MODE`](./miscellaneous.md#maintenance_mode)
* [`MAPS_URL`](./miscellaneous.md#maps_url)
* [`MAX_PAGE_SIZE`](./miscellaneous.md#max_page_size)
* [`PAGINATE_COUNT`](./default-values.md#paginate_count)
* [`POWERFEED_DEFAULT_AMPERAGE`](./default-values.md#powerfeed_default_amperage)
* [`POWERFEED_DEFAULT_MAX_UTILIZATION`](./default-values.md#powerfeed_default_max_utilization)
* [`POWERFEED_DEFAULT_VOLTAGE`](./default-values.md#powerfeed_default_voltage)
* [`PREFER_IPV4`](./miscellaneous.md#prefer_ipv4)
* [`RACK_ELEVATION_DEFAULT_UNIT_HEIGHT`](./default-values.md#rack_elevation_default_unit_height)
* [`RACK_ELEVATION_DEFAULT_UNIT_WIDTH`](./default-values.md#rack_elevation_default_unit_width)

## 구성 수정

구성 파일은 언제든지 수정할 수 있습니다. 그러나 이러한 변경 사항이 적용되기 전에 WSGI 서비스(예: Gunicorn)를 다시 시작해야 합니다:

```no-highlight
$ sudo systemctl restart netbox
```

동적 구성 매개변수(UI를 통해 수정할 수 있는 매개변수)는 즉시 적용됩니다.
