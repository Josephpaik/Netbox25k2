# 설치

<div class="grid cards" markdown>

-   :material-clock-fast:{ .lg .middle } __빨리 시작하고 싶으신가요?__

    ---

    [NetBox Cloud 무료 플랜](https://netboxlabs.com/free-netbox-cloud/)을 확인하세요! 설치 과정을 건너뛰고 미리 구성되어 몇 분 만에 사용할 수 있는 자체 NetBox Cloud 인스턴스를 받으세요. 완전 무료입니다!

    [:octicons-arrow-right-24: 가입하기](https://signup.netboxlabs.com/)

</div>

여기에 제공된 설치 지침은 Ubuntu 22.04에서 작동하도록 테스트되었습니다. 다른 배포판에서 종속성을 설치하는 데 필요한 특정 명령은 크게 다를 수 있습니다. 안타깝게도 이것은 NetBox 메인테이너의 통제 범위를 벗어납니다. 오류가 발생하면 해당 배포판의 문서를 참조하세요.

다음 섹션에서는 새로운 NetBox 인스턴스를 설정하는 방법을 자세히 설명합니다:

1. [PostgreSQL 데이터베이스](1-postgresql.md)
1. [Redis](2-redis.md)
3. [NetBox 컴포넌트](3-netbox.md)
4. [Gunicorn](4a-gunicorn.md) 또는 [uWSGI](4b-uwsgi.md)
5. [HTTP 서버](5-http-server.md)
6. [LDAP 인증](6-ldap.md) (선택 사항)

## 요구 사항

| 종속성      | 지원 버전           |
|------------|---------------------|
| Python     | 3.10, 3.11, 3.12    |
| PostgreSQL | 14+                 |
| Redis      | 4.0+                |

아래는 참조용 NetBox 애플리케이션 스택의 간략한 개요입니다:

![인증되지 않은 사용자가 보는 NetBox UI](../media/installation/netbox_application_stack.png)

## 업그레이드

기존 설치에서 업그레이드하는 경우 [업그레이드 가이드](upgrading.md)를 참조하세요.
