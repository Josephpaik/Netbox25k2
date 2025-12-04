# Google

이 가이드는 [Google OAuth2](https://developers.google.com/identity/protocols/oauth2/web-server)를 인증 백엔드로 사용하여 NetBox에 대한 싱글 사인온(SSO) 지원을 구성하는 방법을 설명합니다.

## Google OAuth2 구성

1. [console.cloud.google.com](https://console.cloud.google.com/)에 로그인합니다.
2. NetBox용 새 프로젝트를 만듭니다.
3. "APIs and Services" 아래에서 "OAuth consent screen"을 클릭하고 필요한 정보를 입력합니다.
4. "Credentials" 아래에서 "Create Credentials"를 클릭하고 "OAuth 2.0 Client ID"를 선택합니다. 유형으로 "Web application"을 선택합니다.
    - "Authorized JavaScript origins"는 `http[s]://<netbox>[:<port>]` 형식을 따라야 합니다
    - "Authorized redirect URIs"는 `http[s]://<netbox>[:<port>]/oauth/complete/google-oauth2/` 형식을 따라야 합니다
5. "Client ID" 및 "Client Secret" 값을 편리한 곳에 복사합니다.

!!! note
    Google은 NetBox 호스트 이름에 공개 최상위 도메인(예: `.com`, `.net`)을 사용해야 합니다. IP 주소 사용은 허용되지 않습니다(`127.0.0.1` 제외).

자세한 내용은 [Google 문서](https://developers.google.com/identity/protocols/oauth2/web-server#prerequisites)를 참조하세요.

## NetBox 구성

### 1. 구성 매개변수 입력

`configuration.py`에 다음 구성 매개변수를 입력하고 자신의 값으로 대체합니다:

```python
REMOTE_AUTH_BACKEND = 'social_core.backends.google.GoogleOAuth2'
SOCIAL_AUTH_GOOGLE_OAUTH2_KEY = '{CLIENT_ID}'
SOCIAL_AUTH_GOOGLE_OAUTH2_SECRET = '{CLIENT_SECRET}'
```

### 2. NetBox 다시 시작

새 구성이 적용되도록 NetBox 서비스를 다시 시작합니다. 이는 일반적으로 아래 명령으로 수행됩니다:

```no-highlight
sudo systemctl restart netbox
```

## 테스트

이미 인증된 경우 NetBox에서 로그아웃하고 오른쪽 상단의 "Log In" 버튼을 클릭합니다. 일반 로그인 양식과 Google을 사용하여 인증하는 옵션이 표시됩니다. 해당 링크를 클릭합니다.

![NetBox Google 로그인 양식](../../media/authentication/netbox_google_login.png)

Google의 인증 포털로 리디렉션됩니다. 테스트 계정의 사용자 이름/이메일과 비밀번호를 입력하여 계속합니다. 이 애플리케이션에 계정에 대한 접근 권한을 부여하라는 메시지가 표시될 수도 있습니다.

![NetBox Google 로그인 양식](../../media/authentication/google_login_portal.png)

성공하면 NetBox UI로 다시 리디렉션되고 Google 사용자로 로그인됩니다. 프로필(오른쪽 상단의 버튼 사용)로 이동하여 확인할 수 있습니다.

이 사용자 계정은 NetBox에 로컬로 복제되었으며 이제 그룹과 권한을 할당받을 수 있습니다.
