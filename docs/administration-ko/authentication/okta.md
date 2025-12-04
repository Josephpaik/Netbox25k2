# Okta

이 가이드는 [Okta](https://www.okta.com/)를 인증 백엔드로 사용하여 NetBox에 대한 싱글 사인온(SSO) 지원을 구성하는 방법을 설명합니다.

## Okta 구성

!!! tip "Okta 개발자 계정"
    Okta는 <https://developer.okta.com/>에서 무료 개발자 계정을 제공합니다.

### 1. 테스트 사용자 생성(선택 사항)

테스트에 사용할 새 사용자를 Okta 관리 포털에 생성합니다. 이미 적합한 계정이 생성되어 있다면 이 단계를 건너뛸 수 있습니다.

### 2. 앱 등록 만들기

Okta 관리 대시보드에서 **Applications > Applications**로 이동하고 "Create App Integration" 버튼을 클릭합니다. 로그인 방법으로 "OIDC"를 선택하고 애플리케이션 유형으로 "Web application"을 선택합니다.

![앱 등록 만들기](../../media/authentication/okta_create_app_registration.png)

다음 페이지에서 앱 통합에 이름(예: "NetBox")을 지정하고 로그인 및 로그아웃 URI를 지정합니다. 이러한 URI는 아래 형식을 따라야 합니다:

* 로그인 URI: `https://{netbox}/oauth/complete/okta-openidconnect/`
* 로그아웃 URI: `https://{netbox}/oauth/disconnect/okta-openidconnect/`

![웹 앱 통합](../../media/authentication/okta_web_app_integration.png)

"Assignments"에서 조직에 가장 적합한 접근 제어 설정을 선택합니다. "Save"를 클릭하여 생성을 완료합니다.

완료되면 다음 매개변수를 메모합니다. 이는 NetBox를 구성하는 데 사용됩니다.

* Client ID
* Client secret
* Okta domain

![Okta 통합 매개변수](../../media/authentication/okta_integration_parameters.png)

## NetBox 구성

### 1. 구성 매개변수 입력

`configuration.py`에 다음 구성 매개변수를 입력하고 자신의 값으로 대체합니다:

```python
REMOTE_AUTH_BACKEND = 'social_core.backends.okta_openidconnect.OktaOpenIdConnect'
SOCIAL_AUTH_OKTA_OPENIDCONNECT_KEY = '{Client ID}'
SOCIAL_AUTH_OKTA_OPENIDCONNECT_SECRET = '{Client secret}'
SOCIAL_AUTH_OKTA_OPENIDCONNECT_API_URL = 'https://{Okta domain}/oauth2/'
```

### 2. NetBox 다시 시작

새 구성이 적용되도록 NetBox 서비스를 다시 시작합니다. 이는 일반적으로 아래 명령으로 수행됩니다:

```no-highlight
sudo systemctl restart netbox
```

## 테스트

이미 인증된 경우 NetBox에서 로그아웃하고 오른쪽 상단의 "Log In" 버튼을 클릭합니다. 일반 로그인 양식과 Okta를 사용하여 인증하는 옵션이 표시됩니다. 해당 링크를 클릭합니다.

![NetBox Okta 로그인 양식](../../media/authentication/netbox_okta_login.png)

Okta의 인증 포털로 리디렉션됩니다. 테스트 계정의 사용자 이름/이메일과 비밀번호를 입력하여 계속합니다. 이 애플리케이션에 계정에 대한 접근 권한을 부여하라는 메시지가 표시될 수도 있습니다.

![Okta 로그인 포털](../../media/authentication/okta_login_portal.png)

성공하면 NetBox UI로 다시 리디렉션되고 Okta 사용자로 로그인됩니다. 프로필(오른쪽 상단의 버튼 사용)로 이동하여 확인할 수 있습니다.

이 사용자 계정은 NetBox에 로컬로 복제되었으며 이제 그룹과 권한을 할당받을 수 있습니다.
