# 시스템 매개변수

## BASE_PATH

기본값: `None`

NetBox에 접근할 때 사용할 기본 URL 경로입니다. 스키마나 도메인 이름은 포함하지 마세요. 예를 들어, https://example.com/netbox/에 설치된 경우 다음과 같이 설정합니다:

```python
BASE_PATH = 'netbox/'
```

---

## DATABASE_ROUTERS

기본값: `[]` (빈 목록)

쿼리에 적합한 데이터베이스를 자동으로 선택하는 데 사용할 [데이터베이스 라우터](https://docs.djangoproject.com/en/stable/topics/db/multi-db/)의 반복 가능 객체입니다. 이는 [여러 데이터베이스](./required-parameters.md#databases)가 구성된 경우에만 유용합니다.

---

## DEFAULT_LANGUAGE

기본값: `en-us` (미국 영어)

언어/로케일을 지정하지 않는 요청에 대한 기본 선호 언어/로케일을 정의합니다. (이 매개변수는 Django의 [`LANGUAGE_CODE`](https://docs.djangoproject.com/en/stable/ref/settings/#language-code) 내부 설정에 매핑됩니다.)

---

## DOCS_ROOT

기본값: `$INSTALL_ROOT/docs/`

NetBox 문서에 대한 파일 시스템 경로입니다. 웹 UI에서 상황에 맞는 문서를 제공할 때 사용됩니다. 기본적으로 이것은 루트 NetBox 설치 경로 내의 `docs/` 디렉토리입니다. (포함된 문서를 비활성화하려면 `None`으로 설정하세요.)

---

## EMAIL

이메일을 보내려면 NetBox에 이메일 서버가 구성되어 있어야 합니다. `EMAIL` 구성 매개변수 내에서 다음 항목을 정의할 수 있습니다:

* `SERVER` - 이메일 서버의 호스트 이름 또는 IP 주소(로컬에서 실행하는 경우 `localhost` 사용)
* `PORT` - 연결에 사용할 TCP 포트(기본값: `25`)
* `USERNAME` - 인증에 사용할 사용자 이름
* `PASSWORD` - 인증에 사용할 비밀번호
* `USE_SSL` - 서버에 연결할 때 SSL 사용(기본값: `False`)
* `USE_TLS` - 서버에 연결할 때 TLS 사용(기본값: `False`)
* `SSL_CERTFILE` - PEM 형식 SSL 인증서 파일 경로(선택 사항)
* `SSL_KEYFILE` - PEM 형식 SSL 개인 키 파일 경로(선택 사항)
* `TIMEOUT` - 연결 대기 시간(초 단위, 기본값: `10`)
* `FROM_EMAIL` - NetBox에서 보내는 이메일의 발신자 주소

!!! note
    `USE_SSL`과 `USE_TLS` 매개변수는 상호 배타적입니다.

이메일은 중요한 이벤트가 발생하거나 [로깅](#logging)이 구성된 경우에만 NetBox에서 전송됩니다. 이메일 서버 구성을 테스트하려면 Django에서 NetBox 셸 내에서 접근할 수 있는 편리한 [send_mail()](https://docs.djangoproject.com/en/stable/topics/email/#send-mail) 함수를 제공합니다:

```no-highlight
# python ./manage.py nbshell
>>> from django.core.mail import send_mail
>>> send_mail(
  '테스트 이메일 제목',
  '테스트 이메일 본문',
  'noreply-netbox@example.com',
  ['users@example.com'],
  fail_silently=False
)
```

---

## HOSTNAME

!!! info "이 매개변수는 NetBox v4.4에서 도입되었습니다."

기본값: 시스템 호스트 이름

NetBox가 실행 중인 시스템을 식별하는 사용자 인터페이스에 표시되는 호스트 이름입니다. 정의되지 않은 경우 Python의 `platform.node()`에서 보고하는 시스템 호스트 이름이 기본값입니다.

---

## HTTP_PROXIES

기본값: `None`

NetBox에서 발생하는 아웃바운드 요청(예: 웹훅 요청 전송 시)에 사용할 HTTP 프록시 딕셔너리입니다. 프록시는 [Python requests 라이브러리 문서](https://requests.readthedocs.io/en/latest/user/advanced/#proxies)에 따라 스키마(HTTP 및 HTTPS)별로 지정해야 합니다. 예:

```python
HTTP_PROXIES = {
    'http': 'http://10.10.1.10:3128',
    'https': 'http://10.10.1.10:1080',
}
```

주어진 요청에 사용할 프록시를 결정하는 데 더 많은 유연성이 필요한 경우 [`PROXY_ROUTERS`](#proxy_routers) 매개변수를 통해 하나 이상의 사용자 정의 프록시 라우터를 구현하는 것을 고려하세요.

---

## INTERNAL_IPS

기본값: `('127.0.0.1', '::1')`

디버깅 출력 표시를 제어하는 데 사용되는 시스템 내부로 인식되는 IP 주소 목록입니다. 예를 들어, 디버깅 도구 모음은 나열된 IP 주소 중 하나에서 클라이언트가 NetBox에 접근하는 경우에만 표시됩니다([`DEBUG`](./development.md#debug)가 `True`인 경우).

---

## ISOLATED_DEPLOYMENT

기본값: `False`

인터넷 접근이 없는 NetBox 배포에 대해 이 구성 매개변수를 `True`로 설정하세요. 이렇게 하면 인터넷 접근에 의존하는 기타 기능이 비활성화됩니다.

!!! note
    프록시를 통해 인터넷 접근이 가능한 경우 대신 [`HTTP_PROXIES`](#http_proxies)를 설정하세요.

---

## JINJA2_FILTERS

기본값: `{}`

키가 필터 이름이고 값이 호출 가능한 사용자 정의 Jinja2 필터 딕셔너리입니다. 자세한 내용은 [Jinja2 문서](https://jinja.palletsprojects.com/en/3.1.x/api/#custom-filters)를 참조하세요. 예:

```python
def uppercase(x):
    return str(x).upper()

JINJA2_FILTERS = {
    'uppercase': uppercase,
}
```

---

## LOGGING

기본적으로 INFO 심각도 이상의 모든 메시지가 콘솔에 기록됩니다. 또한 [`DEBUG`](./development.md#debug)가 False이고 이메일 접근이 구성된 경우 ERROR 및 CRITICAL 메시지가 [`ADMINS`](./miscellaneous.md#admins)에 정의된 사용자에게 이메일로 전송됩니다.

NetBox가 실행되는 Django 프레임워크는 로깅 형식 및 대상의 사용자 정의를 허용합니다. 이 설정 구성에 대한 자세한 내용은 [Django 로깅 문서](https://docs.djangoproject.com/en/stable/topics/logging/)를 참조하세요. 다음은 모든 INFO 이상의 메시지를 로컬 파일에 기록하는 예입니다:

```python
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'file': {
            'level': 'INFO',
            'class': 'logging.FileHandler',
            'filename': '/var/log/netbox.log',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['file'],
            'level': 'INFO',
        },
    },
}
```

### 사용 가능한 로거

* `netbox.<app>.<model>` - 모델별 로그 메시지의 일반 형식
* `netbox.auth.*` - 인증 이벤트
* `netbox.api.views.*` - REST API의 비즈니스 로직을 처리하는 뷰
* `netbox.event_rules` - 이벤트 규칙
* `netbox.jobs.*` - 백그라운드 작업
* `netbox.reports.*` - 보고서 실행(`module.name`)
* `netbox.scripts.*` - 사용자 정의 스크립트 실행(`module.name`)
* `netbox.views.*` - 웹 UI의 비즈니스 로직을 처리하는 뷰

---

## MEDIA_ROOT

기본값: `$INSTALL_ROOT/netbox/media/`

미디어 파일(예: 이미지 첨부 파일)이 저장되는 위치의 파일 경로입니다. 기본적으로 이것은 기본 NetBox 설치 경로 내의 `netbox/media/` 디렉토리입니다.

---

## PROXY_ROUTERS

기본값: `["utilities.proxy.DefaultProxyRouter"]`

아웃바운드 HTTP 요청에 사용할 프록시 서버를 결정하는 Python 클래스 목록입니다. 목록의 각 항목은 클래스 자체이거나 클래스에 대한 점으로 구분된 경로일 수 있습니다.

각 클래스의 `route()` 메서드는 프로토콜(예: `http` 및/또는 `https`)별로 정렬된 후보 프록시의 딕셔너리를 반환하거나 실행 가능한 프록시를 결정할 수 없는 경우 None을 반환해야 합니다. 기본 클래스 `DefaultProxyRouter`는 단순히 [`HTTP_PROXIES`](#http_proxies)의 내용을 반환합니다.

---

## REPORTS_ROOT

기본값: `$INSTALL_ROOT/netbox/reports/`

[사용자 정의 보고서](../customization/reports.md)가 보관될 위치의 파일 경로입니다. 기본적으로 이것은 기본 NetBox 설치 경로 내의 `netbox/reports/` 디렉토리입니다.

---

## SCRIPTS_ROOT

기본값: `$INSTALL_ROOT/netbox/scripts/`

[사용자 정의 스크립트](../customization/custom-scripts.md)가 보관될 위치의 파일 경로입니다. 기본적으로 이것은 기본 NetBox 설치 경로 내의 `netbox/scripts/` 디렉토리입니다.

---

## SEARCH_BACKEND

기본값: `'netbox.search.backends.CachedValueSearchBackend'`

원하는 검색 백엔드 클래스에 대한 점으로 구분된 경로입니다. `CachedValueSearchBackend`는 현재 NetBox에서 제공하는 유일한 검색 백엔드이지만, 이 설정을 사용하여 사용자 정의 백엔드를 활성화할 수 있습니다.

---

## STORAGES

[이미지 첨부 파일](../models/extras/imageattachment.md) 및 [사용자 정의 스크립트](../customization/custom-scripts.md)와 같은 업로드된 파일을 처리하기 위한 백엔드 스토리지 엔진입니다. NetBox는 여러 인기 있는 파일 스토리지 서비스에 대한 백엔드를 제공하는 [`django-storages`](https://django-storages.readthedocs.io/en/stable/) 및 [`django-storage-swift`](https://github.com/dennisv/django-storage-swift) 라이브러리와 통합됩니다. 구성되지 않은 경우 로컬 파일 시스템 스토리지가 사용됩니다.

기본적으로 다음 구성이 사용됩니다:

```python
STORAGES = {
    "default": {
        "BACKEND": "django.core.files.storage.FileSystemStorage",
    },
    "staticfiles": {
        "BACKEND": "django.contrib.staticfiles.storage.StaticFilesStorage",
    },
    "scripts": {
        "BACKEND": "extras.storage.ScriptFileSystemStorage",
    },
}
```

`STORAGES` 딕셔너리 내에서 `"default"`는 이미지 업로드에 사용되고, "staticfiles"는 정적 파일에, `"scripts"`는 사용자 정의 스크립트에 사용됩니다.

S3와 같은 원격 스토리지를 사용하는 경우 필요에 따라 각 스토리지 항목에 대해 `STORAGES[key]["OPTIONS"]`로 구성을 정의하세요. 예:

```python
STORAGES = {
    "scripts": {
        "BACKEND": "storages.backends.s3boto3.S3Boto3Storage",
        "OPTIONS": {
            'access_key': 'access key',
            'secret_key': 'secret key',
        }
    },
}
```

각 스토리지 백엔드에 대한 특정 구성 설정은 [django-storages 문서](https://django-storages.readthedocs.io/en/latest/index.html)에서 찾을 수 있습니다.

!!! note
    `STORAGES` 구성 매개변수에 정의된 키는 기본 구성의 키를 대체합니다. 구성하려는 특정 백엔드에 대해서만 `STORAGES` 내에 키를 정의하면 됩니다.

### 환경 변수 및 타사 라이브러리

NetBox는 자동 환경 변수 감지 대신 명시적인 Python 구성 방식을 사용합니다. 이는 명확한 구성 관리 및 버전 제어 기능을 제공하지만, `django-storages`와 같은 일부 타사 라이브러리가 NetBox 컨텍스트 내에서 작동하는 방식에 영향을 미칩니다.

많은 Django 라이브러리(`django-storages` 포함)는 `AWS_STORAGE_BUCKET_NAME` 또는 `AWS_S3_ACCESS_KEY_ID`와 같은 환경 변수를 자동으로 감지할 것으로 예상합니다. 그러나 NetBox의 구성 처리로 인해 이러한 라이브러리 중 일부에 문서화된 대로 이 자동 감지가 작동하지 않습니다.

환경 변수 감지에 의존하는 타사 라이브러리를 사용할 때는 NetBox `configuration.py`에서 환경 변수를 명시적으로 읽어야 할 수 있습니다:

```python
import os

STORAGES = {
    'default': {
        'BACKEND': 'storages.backends.s3.S3Storage',
        'OPTIONS': {
            'bucket_name': os.environ.get('AWS_STORAGE_BUCKET_NAME'),
            'access_key': os.environ.get('AWS_S3_ACCESS_KEY_ID'),
            'secret_key': os.environ.get('AWS_S3_SECRET_ACCESS_KEY'),
            'endpoint_url': os.environ.get('AWS_S3_ENDPOINT_URL'),
            'location': 'media/',
        }
    },
    'staticfiles': {
        'BACKEND': 'storages.backends.s3.S3Storage',
        'OPTIONS': {
            'bucket_name': os.environ.get('AWS_STORAGE_BUCKET_NAME'),
            'access_key': os.environ.get('AWS_S3_ACCESS_KEY_ID'),
            'secret_key': os.environ.get('AWS_S3_SECRET_ACCESS_KEY'),
            'endpoint_url': os.environ.get('AWS_S3_ENDPOINT_URL'),
            'location': 'static/',
        }
    },
}
```

이 접근 방식은 환경 변수가 NetBox의 구성 처리 중에 해결되기 때문에 작동하며, 타사 라이브러리가 자체 환경 변수 감지를 시도하기 전에 해결됩니다.

!!! warning "구성 동작"
    구성에서 명시적으로 읽지 않고 `AWS_STORAGE_BUCKET_NAME`과 같은 환경 변수를 설정하는 것만으로는 작동하지 않습니다. 변수는 `configuration.py` 파일 내에서 `os.environ.get()`을 사용하여 읽어야 합니다.

---

## TIME_ZONE

기본값: `"UTC"`

NetBox가 날짜와 시간을 처리할 때 사용하는 시간대입니다. 현지 시간대를 사용해야 하는 특별한 이유가 없는 한 UTC 시간을 사용하는 것이 좋습니다. [사용 가능한 시간대 목록](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)을 참조하세요.

---

## TRANSLATION_ENABLED

기본값: `True`

사용자 인터페이스에 대한 언어 번역을 활성화합니다. (이 매개변수는 Django의 [USE_I18N](https://docs.djangoproject.com/en/stable/ref/settings/#std-setting-USE_I18N) 설정에 매핑됩니다.)
