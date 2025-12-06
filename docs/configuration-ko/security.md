# 보안 및 인증 매개변수

## ALLOW_TOKEN_RETRIEVAL

기본값: `False`

!!! note
    이 매개변수의 기본값은 NetBox v4.3.0에서 `True`에서 `False`로 변경되었습니다.

비활성화하면 각 토큰의 초기 생성 후 API 토큰 값이 표시되지 않습니다. 사용자는 생성 전에 토큰 값을 **반드시** 기록해야 합니다. 그렇지 않으면 손실됩니다. 이는 할당된 권한에 관계없이 _모든_ 사용자에게 영향을 미칩니다.

---

## ALLOWED_URL_SCHEMES

!!! tip "동적 구성 매개변수"

기본값: `('file', 'ftp', 'ftps', 'http', 'https', 'irc', 'mailto', 'sftp', 'ssh', 'tel', 'telnet', 'tftp', 'vnc', 'xmpp')`

NetBox 내에서 링크를 렌더링할 때 참조되는 허용된 URL 스키마 목록입니다. 지정된 스키마만 허용됩니다: 자체 스키마를 추가하는 경우 원하지 않는 스키마를 제외하고 모든 기본값을 복제해야 합니다.

---

## AUTH_PASSWORD_VALIDATORS

이 매개변수는 로컬 사용자 계정에 대한 Django의 내장 비밀번호 유효성 검사기를 구성하기 위한 패스스루 역할을 합니다. 이러한 규칙은 사용자의 비밀번호가 생성되거나 업데이트될 때마다 적용되어 길이나 복잡성과 같은 최소 기준을 충족하는지 확인합니다. 기본 구성은 아래와 같습니다.

```python
AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
        "OPTIONS": {
            "min_length": 12,
        },
    },
    {
        "NAME": "utilities.password_validation.AlphanumericPasswordValidator",
    },
]
```

기본 구성은 다음 기준을 적용합니다:

* 비밀번호는 최소 12자 이상이어야 합니다.
* 비밀번호에는 최소 하나의 대문자, 하나의 소문자 및 하나의 숫자가 포함되어야 합니다.

권장되지는 않지만 구성 파일에서 `AUTH_PASSWORD_VALIDATORS = []`를 설정하여 기본 유효성 검사 규칙을 비활성화할 수 있습니다. 비밀번호 유효성 검사 사용자 정의에 대한 자세한 내용은 [Django 문서](https://docs.djangoproject.com/en/stable/topics/auth/passwords/#password-validation)를 참조하세요.

---

## CORS_ORIGIN_ALLOW_ALL

기본값: `False`

`True`인 경우 모든 출처에서 교차 출처 리소스 공유(CORS) 요청이 허용됩니다. False인 경우 화이트리스트가 사용됩니다(아래 참조).

---

## CORS_ORIGIN_WHITELIST

## CORS_ORIGIN_REGEX_WHITELIST

이러한 설정은 교차 사이트 API 요청을 수행할 수 있는 출처 목록을 지정합니다. 정확한 호스트 이름 목록을 정의하려면 `CORS_ORIGIN_WHITELIST`를 사용하고, 정규 표현식 집합을 정의하려면 `CORS_ORIGIN_REGEX_WHITELIST`를 사용하세요. (`CORS_ORIGIN_ALLOW_ALL`이 `True`인 경우 이러한 설정은 효과가 없습니다.) 예:

```python
CORS_ORIGIN_WHITELIST = [
    'https://example.com',
]
```

---

## CSRF_COOKIE_NAME

기본값: `csrftoken`

교차 사이트 요청 위조(CSRF) 인증 토큰에 사용할 쿠키 이름입니다. 자세한 내용은 [Django 문서](https://docs.djangoproject.com/en/stable/ref/settings/#csrf-cookie-name)를 참조하세요.

---

## CSRF_COOKIE_SECURE

기본값: `False`

`True`인 경우 교차 사이트 요청 위조(CSRF) 보호에 사용되는 쿠키가 보안으로 표시되며, 이는 HTTPS 연결을 통해서만 전송될 수 있음을 의미합니다.

---

## CSRF_TRUSTED_ORIGINS

기본값: `[]`

안전하지 않은(예: `POST`) 요청에 대해 신뢰할 수 있는 출처 목록을 정의합니다. 이것은 Django의 [`CSRF_TRUSTED_ORIGINS`](https://docs.djangoproject.com/en/stable/ref/settings/#csrf-trusted-origins) 설정에 대한 패스스루입니다. 나열된 각 호스트는 스키마를 지정해야 합니다(예: `http://` 또는 `https://`).

```python
CSRF_TRUSTED_ORIGINS = (
    'http://netbox.local',
    'https://netbox.local',
)
```

---

## DEFAULT_PERMISSIONS

기본값:

```python
{
    'users.view_token': ({'user': '$user'},),
    'users.add_token': ({'user': '$user'},),
    'users.change_token': ({'user': '$user'},),
    'users.delete_token': ({'user': '$user'},),
}
```

이 매개변수는 데이터베이스에 정의된 권한에 관계없이 _모든_ 인증된 사용자에게 자동으로 적용되는 객체 권한을 정의합니다. 기본적으로 이 매개변수는 모든 사용자가 자신의 API 토큰을 관리할 수 있도록 정의되어 있지만, 다른 목적으로 재정의할 수 있습니다.

예를 들어, 모든 사용자가 "temp"라는 단어로 시작하는 장비 역할을 생성할 수 있도록 허용하려면 다음과 같이 구성할 수 있습니다:

```python
DEFAULT_PERMISSIONS = {
    'dcim.add_devicerole': (
        {'name__startswith': 'temp'},
    )
}
```

!!! warning
    이 매개변수에 대한 사용자 정의 값을 설정하면 위에 표시된 기본 권한 매핑이 덮어쓰기됩니다. 기본 매핑을 유지하려면 사용자 정의 구성에서 재현해야 합니다.

---

## EXEMPT_VIEW_PERMISSIONS

기본값: `[]` (빈 목록)

보기 권한 적용에서 제외할 NetBox 모델 목록입니다. 여기에 나열된 모델은 인증된 사용자와 익명 사용자 모두가 볼 수 있습니다.

`<app>.<model>` 형식으로 모델을 나열하세요. 예:

```python
EXEMPT_VIEW_PERMISSIONS = [
    'dcim.site',
    'dcim.region',
    'ipam.prefix',
]
```

보기 권한 적용에서 _모든_ 모델을 제외하려면 다음을 설정하세요. (`EXEMPT_VIEW_PERMISSIONS`는 반복 가능해야 합니다.)

```python
EXEMPT_VIEW_PERMISSIONS = ['*']
```

!!! note
    와일드카드를 사용해도 사용자 권한과 같은 잠재적으로 민감한 특정 모델에는 영향을 미치지 않습니다. 이러한 모델을 제외해야 하는 경우 개별적으로 지정해야 합니다.

---

## LOGIN_PERSISTENCE

기본값: `False`

`True`인 경우 각 유효한 요청에 따라 사용자 인증 세션의 수명이 자동으로 재설정됩니다. 예를 들어, [`LOGIN_TIMEOUT`](#login_timeout)이 14일(기본값)로 구성되어 있고 세션이 5일 후에 만료될 사용자가 NetBox 요청을 수행하면(유효한 세션 쿠키와 함께) 세션 수명이 14일로 재설정됩니다.

이 설정을 활성화하면 NetBox가 각 요청마다 데이터베이스(또는 [`SESSION_FILE_PATH`](#session_file_path)에 따라 구성된 파일)에서 사용자 세션을 업데이트하므로 매우 활발한 환경에서 상당한 오버헤드가 발생할 수 있습니다. 또한 활성 사용자가 무기한으로 NetBox에 인증된 상태를 유지할 수 있습니다.

---

## LOGIN_REQUIRED

기본값: `True`

활성화하면 인증된 사용자만 NetBox의 모든 부분에 접근할 수 있습니다. 이를 비활성화하면 인증되지 않은 사용자가 NetBox의 대부분 영역에 접근할 수 있습니다(단, 변경은 불가능).

!!! info "NetBox v4.0.2에서 변경됨"
    NetBox v4.0.2 이전에는 이 설정이 기본적으로 비활성화되어 있었습니다.

---

## LOGIN_TIMEOUT

기본값: `1209600`초(14일)

로그인 시 NetBox 사용자에게 발급되는 인증 쿠키의 수명(초)입니다.

---

## LOGIN_FORM_HIDDEN

기본값: `False`

SSO 인증만 사용할 때 로그인 양식을 숨기는 옵션입니다.

!!! warning
    이 옵션이 활성화되어 있고 SSO 공급자에 연결할 수 없는 경우 NetBox에 로그인할 수 없습니다. 유일한 해결 방법은 로컬 구성에서 이를 비활성화하고 NetBox 서비스를 다시 시작하는 것입니다.

---

## LOGOUT_REDIRECT_URL

기본값: `'home'`

로그아웃 후 사용자가 리디렉션되는 뷰 이름 또는 URL입니다.

---

## SECURE_HSTS_INCLUDE_SUBDOMAINS

기본값: `False`

`True`인 경우 HTTP Strict Transport Security(HSTS) 헤더에 `includeSubDomains` 지시문이 포함됩니다. 이 지시문은 브라우저에 HSTS 정책을 현재 도메인의 모든 하위 도메인에 적용하도록 지시합니다.

---

## SECURE_HSTS_PRELOAD

기본값: `False`

`True`인 경우 HTTP Strict Transport Security(HSTS) 헤더에 `preload` 지시문이 포함됩니다. 이 지시문은 브라우저에 HTTPS에서 사이트를 미리 로드하도록 지시합니다. HSTS 미리 로드 목록을 사용하는 브라우저는 사용자가 주소 표시줄에 HTTP를 입력하더라도 사이트를 HTTPS를 통해 강제로 접근하도록 합니다.

---

## SECURE_HSTS_SECONDS

기본값: `0`

0이 아닌 정수 값으로 설정하면 SecurityMiddleware가 아직 HSTS 헤더가 없는 모든 응답에 HTTP Strict Transport Security(HSTS) 헤더를 설정합니다. 이렇게 하면 브라우저에 HTTPS를 통해 웹사이트에 접근해야 함을 알리고 HTTP 요청을 차단합니다.

---

## SECURE_SSL_REDIRECT

기본값: `False`

`True`인 경우 모든 비HTTPS 요청이 자동으로 HTTPS를 사용하도록 리디렉션됩니다.

!!! warning
    이 옵션을 활성화하기 전에 프론트엔드 HTTP 데몬이 HTTP 스키마를 올바르게 전달하도록 구성되었는지 확인하세요. 잘못 구성된 프론트엔드는 리디렉션 루프를 초래할 수 있습니다.

---

## SESSION_COOKIE_NAME

기본값: `sessionid`

세션 쿠키에 사용되는 이름입니다. 자세한 내용은 [Django 문서](https://docs.djangoproject.com/en/stable/ref/settings/#session-cookie-name)를 참조하세요.

---

## SESSION_COOKIE_SECURE

기본값: `False`

`True`인 경우 세션 인증에 사용되는 쿠키가 보안으로 표시되며, 이는 HTTPS 연결을 통해서만 전송될 수 있음을 의미합니다.

---

## SESSION_FILE_PATH

기본값: `None`

HTTP 세션 데이터는 사용자가 NetBox에 접근할 때 인증된 사용자를 추적하는 데 사용됩니다. 기본적으로 NetBox는 PostgreSQL 데이터베이스에 세션 데이터를 저장합니다. 그러나 이로 인해 데이터베이스에 대한 쓰기 권한 없이 NetBox의 대기 인스턴스에 인증할 수 없습니다. 또는 여기에 로컬 파일 경로를 지정하면 NetBox가 데이터베이스 대신 파일로 세션 데이터를 저장합니다. NetBox 시스템 사용자는 이 경로에 대한 읽기 및 쓰기 권한이 있어야 합니다.
