# 인증 및 권한

## 객체 기반 권한

NetBox는 기본 Django 프레임워크의 모델 기반 권한을 훨씬 뛰어넘는 매우 강력한 권한 시스템을 자랑합니다. NetBox에서 권한 할당에는 여러 차원이 포함됩니다:

* 권한이 적용되는 객체 유형
* 권한이 부여되는 사용자 및/또는 그룹
* 권한에 의해 허용되는 작업(예: view, add, change 등)
* 권한 적용을 특정 객체 하위 집합으로 제한하는 제약 조건

제약 조건의 구현을 통해 NetBox 관리자는 객체별 권한을 할당할 수 있습니다: 사용자는 객체의 속성을 기반으로 임의의 객체 하위 집합만 보거나 상호 작용하도록 제한될 수 있습니다. 예를 들어 특정 사용자가 특정 VRF 내의 프리픽스 또는 IP 주소만 볼 수 있도록 제한하거나, 그룹이 특정 지역 내의 장비만 수정하도록 제한할 수 있습니다.

권한 제약 조건은 권한 생성 시 JSON 형식으로 선언되며 Django ORM 쿼리와 매우 유사하게 작동합니다. 예를 들어 VLAN ID가 100에서 199 사이인 reserved VLAN과 일치하는 제약 조건은 다음과 같습니다:

```json
[
  {
    "vid__gte": 100,
    "vid__lt": 200
  },
  {
    "status": "reserved"
  }
]
```

권한 제약 조건에 대한 자세한 내용은 [권한 문서](../administration/permissions.md)를 확인하세요.

## LDAP 인증

NetBox에는 원격 LDAP 서버에 대해 사용자를 인증하기 위한 기본 제공 인증 백엔드가 포함되어 있습니다. [설치 문서](../installation/6-ldap.md)에서 이 기능에 대한 자세한 내용을 제공합니다.

## 싱글 사인온(SSO)

NetBox는 오픈 소스 [python-social-auth](https://github.com/python-social-auth) 라이브러리와 통합하여 싱글 사인온(SSO) 인증을 위한 [다양한 옵션](https://python-social-auth.readthedocs.io/en/latest/backends/index.html#supported-backends)을 제공합니다. 여기에는 다음이 포함됩니다:

* Cognito
* GitHub 및 GitHub Enterprise
* GitLab
* Google
* Hashicorp Vault
* Keycloak
* Microsoft Entra ID
* Microsoft Graph
* Okta
* OIDC

...및 기타 많은 옵션. python-social-auth의 기본 OAuth, OpenID 및 SAML 클래스를 사용하여 필요에 따라 자체 사용자 정의 백엔드를 구축하는 것도 가능합니다. NetBox의 [인증 문서](../administration/authentication/overview.md)에서 SSO 구성의 몇 가지 예를 찾을 수 있습니다.
