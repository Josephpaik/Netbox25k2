# Gunicorn

!!! tip
    이 페이지는 [gunicorn](http://gunicorn.org/) WSGI 서버 설정 지침을 제공합니다. 대신 [uWSGI](https://uwsgi-docs.readthedocs.io/en/latest/)를 사용하려면 [여기](./4b-uwsgi.md)로 이동하세요.

NetBox는 HTTP 서버 뒤에서 [WSGI 애플리케이션](https://en.wikipedia.org/wiki/Web_Server_Gateway_Interface)으로 실행됩니다. 이 문서에서는 이 역할을 위해 [gunicorn](http://gunicorn.org/)(NetBox와 함께 자동으로 설치됨)을 설치하고 구성하는 방법을 보여주지만, 다른 WSGI 서버도 사용 가능하며 유사하게 잘 작동합니다.

## 구성

NetBox는 gunicorn의 기본 구성 파일과 함께 제공됩니다. 사용하려면 `/opt/netbox/contrib/gunicorn.py`를 `/opt/netbox/gunicorn.py`로 복사하세요. (향후 NetBox 업그레이드 시 로컬 변경 사항이 덮어쓰여지지 않도록 직접 가리키지 않고 이 파일의 복사본을 만듭니다.)

```no-highlight
sudo cp /opt/netbox/contrib/gunicorn.py /opt/netbox/gunicorn.py
```

제공된 구성은 대부분의 초기 설치에 충분하지만, 바인딩된 IP 주소 및/또는 포트 번호를 변경하거나 성능 관련 조정을 하기 위해 이 파일을 편집할 수 있습니다. 사용 가능한 구성 매개변수는 [Gunicorn 문서](https://docs.gunicorn.org/en/stable/configure.html)를 참조하세요.

## systemd 설정

systemd를 사용하여 gunicorn과 NetBox의 백그라운드 워커 프로세스를 모두 제어합니다. 먼저 `contrib/netbox.service`와 `contrib/netbox-rq.service`를 `/etc/systemd/system/` 디렉토리에 복사하고 systemd 데몬을 다시 로드합니다.

!!! warning "사용자 및 그룹 할당 확인"
    NetBox와 함께 패키지된 기본 서비스 구성 파일은 서비스가 `netbox` 사용자 및 그룹 이름으로 실행될 것으로 가정합니다. 설치에서 다른 경우 서비스 파일을 적절히 업데이트하세요.

```no-highlight
sudo cp -v /opt/netbox/contrib/*.service /etc/systemd/system/
sudo systemctl daemon-reload
```

그런 다음 `netbox` 및 `netbox-rq` 서비스를 시작하고 부팅 시 시작되도록 활성화합니다:

```no-highlight
sudo systemctl enable --now netbox netbox-rq
```

`systemctl status netbox` 명령을 사용하여 WSGI 서비스가 실행 중인지 확인할 수 있습니다:

```no-highlight
systemctl status netbox.service
```

다음과 유사한 출력이 표시됩니다:

```no-highlight
● netbox.service - NetBox WSGI Service
     Loaded: loaded (/etc/systemd/system/netbox.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-08-30 04:02:36 UTC; 14h ago
       Docs: https://docs.netbox.dev/
   Main PID: 1140492 (gunicorn)
      Tasks: 19 (limit: 4683)
     Memory: 666.2M
     CGroup: /system.slice/netbox.service
             ├─1140492 /opt/netbox/venv/bin/python3 /opt/netbox/venv/bin/gunicorn --pid /va>
             ├─1140513 /opt/netbox/venv/bin/python3 /opt/netbox/venv/bin/gunicorn --pid /va>
             ├─1140514 /opt/netbox/venv/bin/python3 /opt/netbox/venv/bin/gunicorn --pid /va>
...
```

!!! note
    NetBox 서비스가 시작되지 않으면 `journalctl -eu netbox` 명령을 실행하여 문제를 나타낼 수 있는 로그 메시지를 확인하세요.

WSGI 워커가 실행 중인지 확인한 후 HTTP 서버 설정으로 진행합니다.

!!! note
    현재 안정 릴리스의 gunicorn(v21.2.0)에는 워커 프로세스의 자동 재시작이 고부하에서 502 오류를 초래할 수 있는 버그가 있습니다. (자세한 내용은 [gunicorn 버그 #3038](https://github.com/benoitc/gunicorn/issues/3038)을 참조하세요.) 이 문제가 발생한 사용자는 영향을 받지 않는 이전 릴리스의 gunicorn으로 다운그레이드할 수 있습니다(`pip install gunicorn==20.1.0`). 그러나 이 이전 릴리스는 Python 3.11을 공식적으로 지원하지 않습니다.
