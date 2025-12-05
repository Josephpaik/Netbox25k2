![NetBox](netbox_logo_light.svg#only-light "NetBox logo"){style="height: 100px; margin-bottom: 3em; background: none;"}
![NetBox](netbox_logo_dark.svg#only-dark "NetBox logo"){style="height: 100px; margin-bottom: 3em; background: none;"}

# 최고의 네트워크 신뢰 소스 (Source of Truth)

NetBox는 현대 네트워크를 모델링하고 문서화하기 위한 선도적인 솔루션입니다. IP 주소 관리(IPAM)와 데이터센터 인프라 관리(DCIM)의 전통적인 분야를 강력한 API 및 확장 기능과 결합하여, NetBox는 네트워크 자동화를 지원하는 이상적인 "신뢰 소스(source of truth)"를 제공합니다. 전 세계 수천 개의 조직이 왜 NetBox를 인프라의 핵심에 두는지 알아보세요.

[![NetBox UI](./media/screenshots/home-light.png)](./media/screenshots/home-light.png)

## :material-server-network: 네트워크를 위해 설계됨

범용 구성 관리 데이터베이스(CMDB)와 달리, NetBox는 네트워크 엔지니어와 운영자의 요구에 특화된 데이터 모델을 구축했습니다. 인프라 설계와 문서화의 요구를 가장 잘 충족하도록 세심하게 제작된 다양한 객체 타입을 제공합니다. IP 주소 관리부터 케이블링, 오버레이 등 네트워크 기술의 모든 측면을 다룹니다:

* 계층적 지역, 사이트 및 로케이션
* 랙, 장비 및 장비 컴포넌트
* 케이블 및 무선 연결
* 전력 분배 추적
* 데이터 회선 및 제공업체
* 가상 머신 및 클러스터
* IP 프리픽스, 범위 및 주소
* VRF 및 라우트 타겟
* FHRP 그룹 (VRRP, HSRP 등)
* AS 번호
* VLAN 및 범위가 지정된 VLAN 그룹
* L2VPN 오버레이
* 테넌트 할당
* 연락처 관리

## :material-hammer-wrench: 커스터마이징 및 확장 가능

광범위하고 견고한 데이터 모델 외에도, NetBox는 커스터마이징하고 확장할 수 있는 다양한 메커니즘을 제공합니다. 강력한 플러그인 아키텍처를 통해 사용자는 최소한의 개발 노력으로 애플리케이션을 자신의 요구에 맞게 확장할 수 있습니다.

* 커스텀 필드
* 커스텀 모델 유효성 검사
* 익스포트 템플릿
* 이벤트 규칙
* 플러그인
* REST 및 GraphQL API

## :material-lock-open: 항상 오픈

NetBox는 [Apache 2](https://www.apache.org/licenses/LICENSE-2.0.html) 라이선스의 오픈소스 애플리케이션이므로, 전체 코드베이스가 최종 사용자에게 완전히 접근 가능하며 벤더 종속의 위험이 없습니다. 또한, NetBox 개발은 누구나 의견을 제시할 수 있는 완전히 공개적인 커뮤니티 중심 프로세스입니다.

!!! tip "NetBox 개발"
    NetBox에 기여하고 싶으신가요? [GitHub 저장소](https://github.com/netbox-community/netbox)를 확인하여 시작하세요!

## :material-language-python: Python 기반

NetBox는 Python 프로그래밍 언어를 위한 매우 인기 있는 [Django](http://www.djangoproject.com/) 프레임워크를 기반으로 구축되었으며, 이미 네트워크 엔지니어들 사이에서 인기가 높습니다. 사용자는 기존 Python 코딩 스킬을 활용하여 커스텀 스크립트와 플러그인을 통해 NetBox의 이미 방대한 기능을 확장할 수 있습니다.

## :material-flag: 시작하기

* 바로 시작하고 싶다면 [공개 데모](https://demo.netbox.dev/)를 사용해 보세요
* [설치 가이드](./installation/index.md)가 자체 배포를 시작하는 데 도움이 됩니다
* 또는 간편한 접근 방식을 위해 커뮤니티 [Docker 이미지](https://github.com/netbox-community/netbox-docker)를 사용해 보세요
* [NetBox Cloud](https://netboxlabs.com/netbox-cloud)는 [NetBox Labs](https://netboxlabs.com/)에서 제공하는 관리형 솔루션입니다
