# HTTP 서버 설정

이 문서에서는 [nginx](https://www.nginx.com/resources/wiki/)와 [Apache](https://httpd.apache.org/docs/current/) 모두에 대한 예제 구성을 제공하지만, WSGI를 지원하는 모든 HTTP 서버가 호환되어야 합니다.

!!! info
    간결함을 위해 여기서는 Ubuntu 20.04 지침만 제공됩니다. 이러한 작업은 NetBox에 고유하지 않으며 최소한의 변경으로 다른 배포판에도 적용됩니다. 필요한 경우 해당 배포판의 문서를 참조하세요.

## SSL 인증서 획득

NetBox에 대한 HTTPS 접근을 활성화하려면 유효한 SSL 인증서가 필요합니다. 신뢰할 수 있는 상용 제공업체에서 구매하거나, [Let's Encrypt](https://letsencrypt.org/getting-started/)에서 무료로 얻거나, 직접 생성할 수 있습니다(자체 서명된 인증서는 일반적으로 신뢰되지 않음). 공개 인증서와 개인 키 파일 모두 `netbox` 사용자가 읽을 수 있는 위치에 NetBox 서버에 설치해야 합니다.

아래 명령을 사용하여 테스트 목적으로 자체 서명된 인증서를 생성할 수 있지만, 프로덕션에서는 신뢰할 수 있는 기관의 인증서를 사용하는 것이 강력히 권장됩니다. 두 개의 파일이 생성됩니다: 공개 인증서(`netbox.crt`)와 개인 키(`netbox.key`). 인증서는 공개되지만 개인 키는 항상 비밀로 유지해야 합니다.

```no-highlight
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/ssl/private/netbox.key \
-out /etc/ssl/certs/netbox.crt
```

위 명령은 인증서의 추가 세부 정보를 입력하라는 메시지를 표시합니다; 이 모든 항목은 선택 사항입니다.

## HTTP 서버 설치

### 옵션 A: nginx

nginx를 설치하는 것으로 시작합니다:

```no-highlight
sudo apt install -y nginx
```

nginx가 설치되면 NetBox에서 제공하는 nginx 구성 파일을 `/etc/nginx/sites-available/netbox`로 복사합니다. `netbox.example.com`을 설치의 도메인 이름 또는 IP 주소로 교체하세요. (이것은 `configuration.py`의 `ALLOWED_HOSTS`에 구성된 값과 일치해야 합니다.)

```no-highlight
sudo cp /opt/netbox/contrib/nginx.conf /etc/nginx/sites-available/netbox
```

!!! tip "gunicorn vs. uWSGI"
    참조 nginx 구성 파일은 gunicorn이 사용 중이라고 가정합니다. 대신 uWSGI를 사용하는 경우, 계속하기 전에 gunicorn 관련 구성(`proxy_pass` 및 `proxy_set_header`로 시작하는 줄)을 제거하고 그 아래의 uWSGI 섹션의 주석을 해제해야 합니다.

그런 다음 `/etc/nginx/sites-enabled/default`를 삭제하고 방금 생성한 구성 파일에 대한 심볼릭 링크를 `sites-enabled` 디렉토리에 생성합니다.

```no-highlight
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/netbox /etc/nginx/sites-enabled/netbox
```

마지막으로 `nginx` 서비스를 다시 시작하여 새 구성을 사용합니다.

```no-highlight
sudo systemctl restart nginx
```

### 옵션 B: Apache

Apache를 설치하는 것으로 시작합니다:

```no-highlight
sudo apt install -y apache2
```

다음으로 기본 구성 파일을 `/etc/apache2/sites-available/`로 복사합니다. `ServerName` 매개변수를 적절히 수정하세요.

```no-highlight
sudo cp /opt/netbox/contrib/apache.conf /etc/apache2/sites-available/netbox.conf
```

마지막으로 필요한 Apache 모듈이 활성화되어 있는지 확인하고 `netbox` 사이트를 활성화하고 Apache를 다시 로드합니다:

```no-highlight
sudo a2enmod ssl proxy proxy_http headers rewrite
sudo a2ensite netbox
sudo systemctl restart apache2
```

## 연결 확인

이 시점에서 제공한 서버 이름 또는 IP 주소에서 HTTPS 서비스에 연결할 수 있어야 합니다.

!!! info
    여기에 제공된 구성은 NetBox를 시작하고 실행하는 데 필요한 최소한의 구성입니다. 프로덕션 환경에 더 적합하도록 조정할 수 있습니다.

!!! warning
    NetBox의 특정 컴포넌트(예: 랙 엘리베이션 다이어그램 표시)는 임베디드 객체 사용에 의존합니다. HTTP 서버 구성이 NetBox에서 설정한 `X-Frame-Options` 응답 헤더를 재정의하지 않도록 하세요.

## 문제 해결

HTTP 서버에 연결할 수 없는 경우 다음을 확인하세요:

* Nginx/Apache가 실행 중이고 올바른 포트에서 수신하도록 구성되어 있습니다.
* 경로 어딘가에서 방화벽에 의해 접근이 차단되지 않습니다. (서버 자체에서 로컬로 연결해 보세요.)

연결할 수 있지만 502(잘못된 게이트웨이) 오류가 발생하는 경우 다음을 확인하세요:

* WSGI 워커 프로세스(gunicorn)가 실행 중입니다(`systemctl status netbox`가 "active (running)" 상태를 표시해야 함)
* Nginx/Apache가 gunicorn이 수신 중인 포트(기본값은 8001)에 연결하도록 구성되어 있습니다.
* SELinux가 역방향 프록시 연결을 차단하고 있지 않습니다. `setsebool -P httpd_can_network_connect 1` 명령으로 HTTP 네트워크 연결을 허용해야 할 수 있습니다.
