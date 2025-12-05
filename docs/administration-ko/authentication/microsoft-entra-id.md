# Microsoft Entra ID

이 가이드는 [Microsoft Entra ID](https://www.microsoft.com/en-us/security/business/identity-access/microsoft-entra-id)를 인증 백엔드로 사용하여 NetBox에 대한 싱글 사인온(SSO) 지원을 구성하는 방법을 설명합니다.

## Entra ID 구성

### 1. 테스트 사용자 생성(선택 사항)

테스트에 사용할 새 사용자를 AD에 생성합니다. 이미 적합한 계정이 생성되어 있다면 이 단계를 건너뛸 수 있습니다.

### 2. 앱 등록 만들기

Azure Active Directory 대시보드에서 **Add > App registration**으로 이동합니다.

![앱 등록 추가](../../media/authentication/azure_ad_add_app_registration.png)

등록 이름(예: "NetBox")을 입력하고 "single tenant" 옵션이 선택되어 있는지 확인합니다.

"Redirect URI"에서 플랫폼으로 "Web"을 선택하고 `/oauth/complete/azuread-oauth2/`로 끝나는 NetBox 설치 경로를 입력합니다. 이 URI는 localhost를 참조하는 경우(개발 목적)를 제외하고 `https://`로 **시작해야** 합니다.

![앱 등록 매개변수](../../media/authentication/azure_ad_app_registration.png)

완료되면 애플리케이션(클라이언트) ID를 메모합니다. 이는 NetBox를 구성할 때 사용됩니다.

![완료된 앱 등록](../../media/authentication/azure_ad_app_registration_created.png)

!!! tip "멀티테넌트 인증"
    NetBox는 Azure AD를 통한 멀티테넌트 인증도 지원하지만 다른 백엔드와 추가 구성 매개변수가 필요합니다. 멀티테넌트 인증에 관한 자세한 내용은 [`python-social-auth` 문서](https://python-social-auth.readthedocs.io/en/latest/backends/azuread.html#tenant-support)를 참조하세요.

### 3. 비밀 만들기

새로 생성된 앱 등록을 볼 때 "Client credentials" 아래의 "Add a certificate or secret" 링크를 클릭합니다. "Client secrets" 탭에서 "New client secret" 버튼을 클릭합니다.

![클라이언트 비밀 추가](../../media/authentication/azure_ad_add_client_secret.png)

선택적으로 설명을 지정하고 비밀의 수명을 선택할 수 있습니다.

![클라이언트 비밀 매개변수](../../media/authentication/azure_ad_client_secret.png)

완료되면 비밀 값(비밀 ID가 아님)을 메모합니다. 이는 NetBox를 구성할 때 사용됩니다.

![클라이언트 비밀 매개변수](../../media/authentication/azure_ad_client_secret_created.png)

## NetBox 구성

### 1. 구성 매개변수 입력

`configuration.py`에 다음 구성 매개변수를 입력하고 자신의 값으로 대체합니다:

```python
REMOTE_AUTH_BACKEND = 'social_core.backends.azuread.AzureADOAuth2'
SOCIAL_AUTH_AZUREAD_OAUTH2_KEY = '{APPLICATION_ID}'
SOCIAL_AUTH_AZUREAD_OAUTH2_SECRET = '{SECRET_VALUE}'
```

### 2. NetBox 다시 시작

새 구성이 적용되도록 NetBox 서비스를 다시 시작합니다. 이는 일반적으로 아래 명령으로 수행됩니다:

```no-highlight
sudo systemctl restart netbox
```

## 테스트

이미 인증된 경우 NetBox에서 로그아웃하고 오른쪽 상단의 "Log In" 버튼을 클릭합니다. 일반 로그인 양식과 Azure AD를 사용하여 인증하는 옵션이 표시됩니다. 해당 링크를 클릭합니다.

![NetBox Azure AD 로그인 양식](../../media/authentication/netbox_azure_ad_login.png)

Microsoft의 인증 포털로 리디렉션됩니다. 테스트 계정의 사용자 이름/이메일과 비밀번호를 입력하여 계속합니다. 이 애플리케이션에 계정에 대한 접근 권한을 부여하라는 메시지가 표시될 수도 있습니다.

![NetBox Azure AD 로그인 양식](../../media/authentication/azure_ad_login_portal.png)

성공하면 NetBox UI로 다시 리디렉션되고 AD 사용자로 로그인됩니다. 프로필(오른쪽 상단의 버튼 사용)로 이동하여 확인할 수 있습니다.

이 사용자 계정은 NetBox에 로컬로 복제되었으며 이제 그룹과 권한을 할당받을 수 있습니다.

## 문제 해결

### Redirect URI가 일치하지 않음

Azure는 인증하는 클라이언트가 2단계에서 앱에 대해 구성한 것과 일치하는 redirect URI를 요청해야 합니다. 이 URI는 `https://`로 **시작해야** 합니다(도메인에 `localhost`를 사용하는 경우 제외).

Azure가 요청된 URI가 `http://`(HTTPS 아님)로 시작한다고 불평하는 경우 HTTP 서버가 잘못 구성되었거나 로드 밸런서 뒤에 있어 NetBox가 HTTPS가 사용되고 있음을 인식하지 못할 가능성이 높습니다. HTTPS redirect URI 사용을 강제하려면 [python-social-auth 문서](https://python-social-auth.readthedocs.io/en/latest/configuration/settings.html#processing-redirects-and-urlopen)에 따라 `configuration.py`에서 `SOCIAL_AUTH_REDIRECT_IS_HTTPS = True`를 설정하세요.

### 인증 후 로그인되지 않음

성공적으로 인증한 후 NetBox UI로 리디렉션되었지만 로그인되지 _않은_ 경우 구성된 백엔드와 앱 등록을 다시 확인하세요. 이 가이드의 지침은 단일 테넌트 앱 등록을 사용하는 `azuread.AzureADOAuth2` 백엔드에만 해당됩니다.
