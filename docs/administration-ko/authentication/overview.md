# 인증

## 로컬 인증

로컬 사용자 계정과 그룹은 "Admin" 메뉴의 "Authentication" 섹션에서 NetBox에 생성할 수 있습니다. 이 섹션은 "staff" 권한이 활성화된 사용자만 사용할 수 있습니다.

최소한 각 사용자 계정에는 사용자 이름과 비밀번호가 설정되어야 합니다. 사용자 계정은 이름, 성 및 이메일 주소를 나타낼 수도 있습니다. 필요에 따라 개별 사용자 및/또는 그룹에 [권한](../permissions.md)을 할당할 수도 있습니다.

## 원격 인증

NetBox는 로컬 인증 외에도 원격 백엔드를 통해 사용자 인증을 제공하도록 구성할 수 있습니다. 이는 `REMOTE_AUTH_BACKEND` 구성 매개변수를 적절한 백엔드 클래스로 설정하여 수행됩니다. NetBox는 원격 인증을 위한 여러 옵션을 제공합니다.

### LDAP 인증

```python
REMOTE_AUTH_BACKEND = 'netbox.authentication.LDAPBackend'
```

NetBox에는 LDAP를 지원하는 인증 백엔드가 포함되어 있습니다. 이 백엔드에 대한 자세한 내용은 [LDAP 설치 문서](../../installation/6-ldap.md)를 참조하세요.

### HTTP 헤더 인증

```python
REMOTE_AUTH_BACKEND = 'netbox.authentication.RemoteUserBackend'
```

NetBox의 원격 인증을 위한 또 다른 옵션은 HTTP 헤더 기반 사용자 할당을 활성화하는 것입니다. 프론트엔드 HTTP 서버(예: nginx 또는 Apache)는 NetBox 외부의 프로세스로 클라이언트 인증을 수행하고 HTTP 헤더를 통해 인증된 사용자에 대한 정보를 전달합니다. 기본적으로 사용자는 `REMOTE_USER` 헤더를 통해 할당되지만 `REMOTE_AUTH_HEADER` 구성 매개변수를 통해 사용자 정의할 수 있습니다.

선택적으로 `REMOTE_USER_FIRST_NAME`, `REMOTE_USER_LAST_NAME` 및 `REMOTE_USER_EMAIL` 헤더로 사용자 프로필 정보를 제공할 수 있습니다. 이러한 정보는 인증 프로세스 중에 사용자의 프로필에 저장됩니다. 이러한 헤더는 `REMOTE_USER` 헤더처럼 사용자 정의할 수 있습니다.

!!! warning 헤더 호환성 확인
    일부 WSGI 서버는 지원되지 않는 문자가 포함된 헤더를 삭제할 수 있습니다. 예를 들어 gunicorn v22.0 이상은 밑줄이 포함된 HTTP 헤더를 조용히 삭제합니다. 이 동작은 gunicorn의 [`header_map`](https://docs.gunicorn.org/en/stable/settings.html#header-map) 설정을 `dangerous`로 변경하여 비활성화할 수 있습니다.

### 싱글 사인온(SSO)

```python
REMOTE_AUTH_BACKEND = 'social_core.backends.google.GoogleOAuth2'
```

NetBox는 [python-social-auth](https://github.com/python-social-auth) 라이브러리를 통해 싱글 사인온 인증을 지원합니다. SSO를 활성화하려면 `social_core` Python 패키지 내에서 원하는 인증 백엔드의 경로를 지정하세요. 사용 가능한 옵션은 [지원되는 인증 백엔드](https://github.com/python-social-auth/social-core/tree/master/social_core/backends)의 전체 목록을 참조하세요.

대부분의 원격 인증 백엔드는 `SOCIAL_AUTH_` 접두사가 붙은 설정을 통해 추가 구성이 필요합니다. 이러한 설정은 NetBox의 `configuration.py` 파일에서 자동으로 가져옵니다. 또한 [인증 파이프라인](https://python-social-auth.readthedocs.io/en/latest/pipeline.html)은 `SOCIAL_AUTH_PIPELINE` 매개변수를 통해 사용자 정의할 수 있습니다. (NetBox의 기본 파이프라인은 참조용으로 `netbox/settings.py`에 정의되어 있습니다.)

#### SSO 모듈의 외관 구성

원격 인증 백엔드가 로그인 페이지에서 사용자에게 표시되는 방식은 `SOCIAL_AUTH_BACKEND_ATTRS` 매개변수를 통해 조정할 수 있으며, 기본값은 빈 딕셔너리입니다. 이 딕셔너리는 `social_core` 모듈의 이름(즉, `REMOTE_AUTH_BACKEND.name`)을 `(display_name, icon)` 쌍의 매개변수에 매핑합니다.

`display_name`은 로그인 페이지에서 사용자에게 표시되는 이름입니다. 아이콘은 아이콘의 URL이거나, [Material Design Icons](https://github.com/google/material-design-icons) 아이콘의 이름을 참조하거나, 아이콘이 없는 경우 `None`일 수 있습니다.

예를 들어 OIDC 백엔드는 다음과 같이 사용자 정의할 수 있습니다:

```python
SOCIAL_AUTH_BACKEND_ATTRS = {
    'oidc': ("My awesome SSO", "login"),
}
```
