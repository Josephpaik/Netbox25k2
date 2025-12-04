# NetBox 설치

이 문서 섹션에서는 NetBox 애플리케이션 자체의 설치 및 구성에 대해 설명합니다.

## 시스템 패키지 설치

NetBox 및 종속성에 필요한 모든 시스템 패키지를 설치하는 것으로 시작합니다.

!!! warning "Python 3.10 이상 필요"
    NetBox는 Python 3.10, 3.11, 3.12를 지원합니다.

```no-highlight
sudo apt install -y python3 python3-pip python3-venv python3-dev \
build-essential libxml2-dev libxslt1-dev libffi-dev libpq-dev \
libssl-dev zlib1g-dev
```

계속하기 전에 설치된 Python 버전이 3.10 이상인지 확인하세요:

```no-highlight
python3 -V
```

## NetBox 다운로드

이 문서에서는 NetBox를 설치하는 두 가지 옵션을 제공합니다: 다운로드 가능한 아카이브에서 또는 git 저장소에서. 패키지에서 설치(아래 옵션 A)하면 향후 모든 업데이트에 대해 아카이브를 수동으로 가져오고 추출해야 하지만, git을 통한 설치(옵션 B)는 최신 릴리스 태그를 체크아웃하여 원활한 업그레이드가 가능합니다.

### 옵션 A: 릴리스 아카이브 다운로드

GitHub에서 [최신 안정 릴리스](https://github.com/netbox-community/netbox/releases)를 tarball 또는 ZIP 아카이브로 다운로드하여 원하는 경로에 추출합니다. 이 예에서는 NetBox 루트로 `/opt/netbox`를 사용합니다.

```no-highlight
sudo wget https://github.com/netbox-community/netbox/archive/refs/tags/vX.Y.Z.tar.gz
sudo tar -xzf vX.Y.Z.tar.gz -C /opt
sudo ln -s /opt/netbox-X.Y.Z/ /opt/netbox
```

!!! note
    버전 번호로 명명된 디렉토리에 NetBox를 설치하는 것이 좋습니다. 예를 들어, NetBox v3.0.0은 `/opt/netbox-3.0.0`에 설치되고 `/opt/netbox/`의 심볼릭 링크가 이 위치를 가리킵니다. (`ls -l /opt | grep netbox` 명령으로 이 구성을 확인할 수 있습니다.) 이렇게 하면 현재 설치를 중단하지 않고 향후 릴리스를 병렬로 설치할 수 있습니다. 새 릴리스로 변경할 때 심볼릭 링크만 업데이트하면 됩니다.

### 옵션 B: Git 저장소 복제

NetBox 설치를 위한 기본 디렉토리를 생성합니다. 이 가이드에서는 `/opt/netbox`를 사용합니다.

```no-highlight
sudo mkdir -p /opt/netbox/
cd /opt/netbox/
```

`git`이 아직 설치되지 않은 경우 설치합니다:

```no-highlight
sudo apt install -y git
```

다음으로 git 저장소를 복제합니다:

```no-highlight
sudo git clone https://github.com/netbox-community/netbox.git .
```

이 명령은 다음과 유사한 출력을 생성합니다:

```
Cloning into '.'...
remote: Enumerating objects: 996, done.
remote: Counting objects: 100% (996/996), done.
remote: Compressing objects: 100% (935/935), done.
remote: Total 996 (delta 148), reused 386 (delta 34), pack-reused 0
Receiving objects: 100% (996/996), 4.26 MiB | 9.81 MiB/s, done.
Resolving deltas: 100% (148/148), done.
```

마지막으로 원하는 릴리스의 태그를 체크아웃합니다. [릴리스 페이지](https://github.com/netbox-community/netbox/releases)에서 확인할 수 있습니다. 아래에서 `vX.Y.Z`를 선택한 릴리스 태그로 교체하세요.

```
sudo git checkout vX.Y.Z
```

이 설치 방법을 사용하면 최신 릴리스 태그를 체크아웃하기만 하면 향후 쉽게 업그레이드할 수 있습니다.

## NetBox 시스템 사용자 생성

`netbox`라는 시스템 사용자 계정을 생성합니다. 이 계정으로 WSGI 및 HTTP 서비스가 실행되도록 구성합니다. 또한 이 사용자에게 미디어 디렉토리의 소유권을 할당합니다. 이렇게 하면 NetBox가 업로드된 파일을 저장할 수 있습니다.

```
sudo adduser --system --group netbox
sudo chown --recursive netbox /opt/netbox/netbox/media/
sudo chown --recursive netbox /opt/netbox/netbox/reports/
sudo chown --recursive netbox /opt/netbox/netbox/scripts/
```

## 구성

NetBox 구성 디렉토리로 이동하여 `configuration_example.py`를 `configuration.py`라는 이름으로 복사합니다. 이 파일에 모든 로컬 구성 매개변수가 저장됩니다.

```no-highlight
cd /opt/netbox/netbox/netbox/
sudo cp configuration_example.py configuration.py
```

선호하는 편집기로 `configuration.py`를 열어 NetBox 구성을 시작합니다. NetBox는 [많은 구성 매개변수](../configuration/index.md)를 제공하지만, 새 설치에는 다음 네 가지만 필요합니다:

* `ALLOWED_HOSTS`
* `DATABASES` (또는 `DATABASE`)
* `REDIS`
* `SECRET_KEY`

### ALLOWED_HOSTS

이 서버에 접근할 수 있는 유효한 호스트 이름 및 IP 주소 목록입니다. 최소한 하나의 이름 또는 IP 주소를 지정해야 합니다. (이것은 NetBox에 접근할 수 있는 위치를 제한하지 않습니다: 단지 [HTTP 호스트 헤더 검증](https://docs.djangoproject.com/en/stable/topics/security/#host-headers-virtual-hosting)을 위한 것입니다.)

```python
ALLOWED_HOSTS = ['netbox.example.com', '192.0.2.123']
```

NetBox 설치의 도메인 이름 및/또는 IP 주소가 아직 확실하지 않은 경우, 모든 호스트 값을 허용하도록 와일드카드(별표)로 설정할 수 있습니다:

```python
ALLOWED_HOSTS = ['*']
```

### DATABASES

이 매개변수에는 PostgreSQL 데이터베이스 구성 세부 정보가 포함됩니다. 기본 데이터베이스를 정의해야 합니다; 플러그인 등에 필요한 경우 추가 데이터베이스를 정의할 수 있습니다.

기본 데이터베이스에 대한 사용자 이름과 비밀번호를 정의해야 합니다. 서비스가 원격 호스트에서 실행되는 경우 `HOST` 및 `PORT` 매개변수를 적절히 업데이트하세요. 개별 매개변수에 대한 자세한 내용은 [구성 문서](../configuration/required-parameters.md#databases)를 참조하세요.

```python
DATABASES = {
    'default': {
        'NAME': 'netbox',               # 데이터베이스 이름
        'USER': 'netbox',               # PostgreSQL 사용자 이름
        'PASSWORD': 'J5brHrAXFLQSif0K', # PostgreSQL 비밀번호
        'HOST': 'localhost',            # 데이터베이스 서버
        'PORT': '',                     # 데이터베이스 포트 (기본값은 비워둠)
        'CONN_MAX_AGE': 300,            # 최대 데이터베이스 연결 수명 (초)
    }
}
```

### REDIS

Redis는 NetBox에서 캐싱 및 백그라운드 태스크 큐잉에 사용하는 인메모리 키-값 저장소입니다. Redis는 일반적으로 최소한의 구성이 필요합니다; 아래 값은 대부분의 설치에 충분합니다. 개별 매개변수에 대한 자세한 내용은 [구성 문서](../configuration/required-parameters.md#redis)를 참조하세요.

NetBox는 두 개의 별도 Redis 데이터베이스 사양이 필요합니다: `tasks`와 `caching`. 둘 다 동일한 Redis 서비스에서 제공될 수 있지만, 각각 고유한 숫자 데이터베이스 ID를 가져야 합니다.

```python
REDIS = {
    'tasks': {
        'HOST': 'localhost',      # Redis 서버
        'PORT': 6379,             # Redis 포트
        'PASSWORD': '',           # Redis 비밀번호 (선택 사항)
        'DATABASE': 0,            # 데이터베이스 ID
        'SSL': False,             # SSL 사용 (선택 사항)
    },
    'caching': {
        'HOST': 'localhost',
        'PORT': 6379,
        'PASSWORD': '',
        'DATABASE': 1,            # 두 번째 데이터베이스의 고유 ID
        'SSL': False,
    }
}
```

### SECRET_KEY

이 매개변수에는 해싱 및 관련 암호화 함수에 대한 솔트로 사용되는 무작위로 생성된 키를 할당해야 합니다. (그러나 비밀 데이터의 암호화에 직접 사용되지는 _않습니다_.) 이 키는 이 설치에 고유해야 하며 최소 50자 이상을 권장합니다. 로컬 시스템 외부에서 공유해서는 안 됩니다.

적절한 키를 생성하는 데 도움이 되도록 상위 디렉토리에 `generate_secret_key.py`라는 간단한 Python 스크립트가 제공됩니다:

```no-highlight
python3 ../generate_secret_key.py
```

!!! warning "SECRET_KEY 값은 일치해야 함"
    여러 웹 서버가 있는 고가용성 설치의 경우, 지속적인 사용자 세션 상태를 유지하려면 `SECRET_KEY`가 모든 서버에서 동일해야 합니다.

구성 수정을 완료했으면 파일을 저장하는 것을 잊지 마세요.

## 선택적 요구 사항

NetBox에 필요한 모든 Python 패키지는 `requirements.txt`에 나열되어 있으며 자동으로 설치됩니다. NetBox는 일부 선택적 패키지도 지원합니다. 필요한 경우 이러한 패키지를 NetBox 루트 디렉토리의 `local_requirements.txt`에 나열해야 합니다.

### 원격 파일 저장소

기본적으로 NetBox는 업로드된 파일을 저장하기 위해 로컬 파일 시스템을 사용합니다. 원격 파일 시스템을 사용하려면 [`django-storages`](https://django-storages.readthedocs.io/en/stable/) 라이브러리를 설치하고 `configuration.py`에서 [원하는 저장소 백엔드](../configuration/system.md#storages)를 구성하세요.

```no-highlight
sudo sh -c "echo 'django-storages' >> /opt/netbox/local_requirements.txt"
```

### 원격 데이터 소스

NetBox는 구성 가능한 백엔드를 통해 여러 원격 데이터 소스와의 통합을 지원합니다. 각각에는 하나 이상의 추가 라이브러리 설치가 필요합니다.

* Amazon S3: [`boto3`](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)
* Git: [`dulwich`](https://www.dulwich.io/)

예를 들어, Amazon S3 백엔드를 활성화하려면 로컬 요구 사항 파일에 `boto3`를 추가하세요:

```no-highlight
sudo sh -c "echo 'boto3' >> /opt/netbox/local_requirements.txt"
```

!!! info
    이러한 패키지는 이전에 NetBox v3.5에서 필수였지만 현재는 선택 사항입니다.

### Sentry 통합

NetBox는 분석을 위해 [Sentry](../administration/error-reporting.md)에 오류 보고서를 보내도록 구성할 수 있습니다. 이 통합에는 `sentry-sdk` Python 라이브러리 설치가 필요합니다.

```no-highlight
sudo sh -c "echo 'sentry-sdk' >> /opt/netbox/local_requirements.txt"
```

!!! info
    Sentry 통합은 이전에 NetBox v3.6에 기본적으로 포함되었지만 현재는 선택 사항입니다.

## 업그레이드 스크립트 실행

NetBox가 구성되면 실제 설치를 진행할 준비가 되었습니다. 패키지된 업그레이드 스크립트(`upgrade.sh`)를 실행하여 다음 작업을 수행합니다:

* Python 가상 환경 생성
* 모든 필수 Python 패키지 설치
* 데이터베이스 스키마 마이그레이션 실행 (`--readonly`로 건너뛰기)
* 문서를 로컬로 빌드 (오프라인 사용)
* 디스크에 정적 리소스 파일 집계

!!! warning
    이전 설치 단계에서 Python 가상 환경이 아직 활성화되어 있는 경우 `deactivate` 명령을 실행하여 비활성화하세요. 이렇게 하면 `sudo`가 사용자의 현재 환경을 유지하도록 구성된 시스템에서 오류를 방지할 수 있습니다.

```no-highlight
sudo /opt/netbox/upgrade.sh
```

NetBox v4.0 이상 릴리스에는 **Python 3.10 이상이 필요합니다**. 서버의 기본 Python 설치가 더 낮은 버전으로 설정된 경우, 지원되는 설치 경로를 `PYTHON`이라는 환경 변수로 전달하세요. (환경 변수는 `sudo` 명령 _다음에_ 전달해야 합니다.)

```no-highlight
sudo PYTHON=/usr/bin/python3.10 /opt/netbox/upgrade.sh
```

!!! note
    완료 시 업그레이드 스크립트가 기존 가상 환경이 감지되지 않았다는 경고를 표시할 수 있습니다. 이것은 새 설치이므로 이 경고는 무시해도 됩니다.

!!! note
    읽기 전용 모드로 데이터베이스에 연결된 노드에서 스크립트를 실행하려면 `--readonly` 매개변수를 포함하세요. 이렇게 하면 데이터베이스 마이그레이션 적용을 건너뜁니다.

## 슈퍼 사용자 생성

NetBox에는 미리 정의된 사용자 계정이 없습니다. NetBox에 로그인하려면 슈퍼 사용자(관리 계정)를 생성해야 합니다. 먼저 업그레이드 스크립트에서 생성한 Python 가상 환경에 들어갑니다:

```no-highlight
source /opt/netbox/venv/bin/activate
```

가상 환경이 활성화되면 콘솔 프롬프트 앞에 `(venv)` 문자열이 추가됩니다.

다음으로 `createsuperuser` Django 관리 명령(`manage.py`를 통해)을 사용하여 슈퍼 사용자 계정을 생성합니다. 사용자의 이메일 주소 지정은 필수가 아니지만 매우 강력한 비밀번호를 사용하세요.

```no-highlight
cd /opt/netbox/netbox
python3 manage.py createsuperuser
```

## 애플리케이션 테스트

이 시점에서 테스트를 위해 NetBox의 개발 서버를 실행할 수 있어야 합니다. 로컬에서 개발 인스턴스를 시작하여 확인할 수 있습니다.

!!! tip
    서버를 실행하기 전에 Python 가상 환경이 아직 활성화되어 있는지 확인하세요.

```no-highlight
python3 manage.py runserver 0.0.0.0:8000 --insecure
```

성공하면 다음과 유사한 출력이 표시됩니다:

```no-highlight
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).
August 30, 2021 - 18:02:23
Django version 3.2.6, using settings 'netbox.settings'
Starting development server at http://127.0.0.1:8000/
Quit the server with CONTROL-C.
```

다음으로 포트 8000에서 서버의 이름 또는 IP(`ALLOWED_HOSTS`에 정의된 대로)에 연결합니다. 예: <http://127.0.0.1:8000/>. NetBox 홈 페이지가 표시됩니다. 슈퍼 사용자를 생성할 때 지정한 사용자 이름과 비밀번호로 로그인해 보세요.

!!! danger "프로덕션 용도가 아님"
    개발 서버는 개발 및 테스트 목적으로만 사용됩니다. 프로덕션 용도로 사용하기에는 성능이나 보안이 충분하지 않습니다. **프로덕션에서 사용하지 마세요.**

!!! warning
    테스트 서비스가 실행되지 않거나 NetBox 홈 페이지에 접근할 수 없는 경우 문제가 발생한 것입니다. 설치가 수정될 때까지 이 가이드의 나머지 부분을 진행하지 마세요.

`Ctrl+c`를 입력하여 개발 서버를 중지합니다.
