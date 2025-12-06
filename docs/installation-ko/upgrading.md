# 새로운 NetBox 릴리스로 업그레이드

NetBox를 새 버전으로 업그레이드하는 것은 매우 간단하지만, 업그레이드를 시작하기 전에 항상 릴리스 노트를 검토하고 현재 배포의 백업을 저장하는 것이 좋습니다.

NetBox는 일반적으로 중간 단계 없이 모든 최신 릴리스로 직접 업그레이드할 수 있지만, 주요 버전을 증가시키는 경우는 예외입니다. 이것은 주요 버전의 가장 최근 _마이너_ 릴리스에서만 수행할 수 있습니다. 예를 들어, NetBox v2.11.8은 아래 단계에 따라 버전 3.3.2로 업그레이드할 수 있습니다. 그러나 NetBox v2.10.10 이하 배포는 먼저 v2.11 릴리스로 업그레이드한 다음 v3.x 릴리스로 업그레이드해야 합니다. (이것은 주요 버전 변경에 의해 영향을 받는 데이터베이스 스키마 마이그레이션의 통합을 수용하기 위함입니다.)

[![업그레이드 경로](../media/installation/upgrade_paths.png)](../media/installation/upgrade_paths.png)

!!! warning "백업 수행"
    업그레이드 프로세스를 시작하기 전에 항상 현재 NetBox 배포의 백업을 저장하세요.

## 1. 릴리스 노트 검토

NetBox 인스턴스를 업그레이드하기 전에 현재 버전이 릴리스된 이후에 게시된 모든 [릴리스 노트](../release-notes/index.md)를 주의 깊게 검토하세요. 업그레이드 프로세스에는 일반적으로 추가 작업이 필요하지 않지만, 특정 릴리스에서는 호환성을 깨뜨리거나 이전 버전과 호환되지 않는 변경 사항이 도입될 수 있습니다. 이러한 사항은 변경이 적용된 릴리스 아래의 릴리스 노트에 명시되어 있습니다.

## 2. 종속성을 필수 버전으로 업데이트

NetBox에는 다음 종속성이 필요합니다:

| 종속성      | 지원 버전           |
|------------|---------------------|
| Python     | 3.10, 3.11, 3.12    |
| PostgreSQL | 14+                 |
| Redis      | 4.0+                |

### 버전 이력

| NetBox 버전 | Python 최소 | Python 최대 | PostgreSQL 최소 | Redis 최소 |                                       문서                                       |
|:-----------:|:-----------:|:-----------:|:--------------:|:---------:|:-----------------------------------------------------------------------------------------:|
|     4.4     |    3.10     |    3.12     |       14       |    4.0    | [링크](https://github.com/netbox-community/netbox/blob/v4.4.0/docs/installation/index.md) |
|     4.3     |    3.10     |    3.12     |       14       |    4.0    | [링크](https://github.com/netbox-community/netbox/blob/v4.3.0/docs/installation/index.md) |
|     4.2     |    3.10     |    3.12     |       13       |    4.0    | [링크](https://github.com/netbox-community/netbox/blob/v4.2.0/docs/installation/index.md) |
|     4.1     |    3.10     |    3.12     |       12       |    4.0    | [링크](https://github.com/netbox-community/netbox/blob/v4.1.0/docs/installation/index.md) |
|     4.0     |    3.10     |    3.12     |       12       |    4.0    | [링크](https://github.com/netbox-community/netbox/blob/v4.0.0/docs/installation/index.md) |
|     3.7     |    3.8      |    3.11     |       12       |    4.0    | [링크](https://github.com/netbox-community/netbox/blob/v3.7.0/docs/installation/index.md) |
|     3.6     |    3.8      |    3.11     |       12       |    4.0    | [링크](https://github.com/netbox-community/netbox/blob/v3.6.0/docs/installation/index.md) |
|     3.5     |    3.8      |    3.10     |       11       |    4.0    | [링크](https://github.com/netbox-community/netbox/blob/v3.5.0/docs/installation/index.md) |
|     3.4     |    3.8      |    3.10     |       11       |    4.0    | [링크](https://github.com/netbox-community/netbox/blob/v3.4.0/docs/installation/index.md) |
|     3.3     |    3.8      |    3.10     |       10       |    4.0    | [링크](https://github.com/netbox-community/netbox/blob/v3.3.0/docs/installation/index.md) |
|     3.2     |    3.8      |    3.10     |       10       |    4.0    | [링크](https://github.com/netbox-community/netbox/blob/v3.2.0/docs/installation/index.md) |
|     3.1     |    3.7      |    3.9      |       10       |    4.0    | [링크](https://github.com/netbox-community/netbox/blob/v3.1.0/docs/installation/index.md) |
|     3.0     |    3.7      |    3.9      |      9.6       |    4.0    | [링크](https://github.com/netbox-community/netbox/blob/v3.0.0/docs/installation/index.md) |

## 3. 최신 릴리스 설치

초기 설치와 마찬가지로 최신 릴리스 패키지를 다운로드하거나 git 저장소에서 최신 프로덕션 릴리스를 체크아웃하여 NetBox를 업그레이드할 수 있습니다.

!!! warning
    원래 NetBox를 설치할 때 사용한 것과 동일한 방법을 사용하세요.

NetBox가 원래 어떻게 설치되었는지 확실하지 않은 경우 다음 명령으로 확인하세요:

```
ls -ld /opt/netbox /opt/netbox/.git
```

NetBox가 릴리스 패키지에서 설치된 경우 `/opt/netbox`는 현재 버전을 가리키는 심볼릭 링크이고 `/opt/netbox/.git`는 존재하지 않습니다. git에서 설치된 경우 `/opt/netbox`와 `/opt/netbox/.git` 모두 일반 디렉토리로 존재합니다.

### 옵션 A: 릴리스 다운로드

GitHub에서 [최신 안정 릴리스](https://github.com/netbox-community/netbox/releases)를 tarball 또는 ZIP 아카이브로 다운로드합니다. 원하는 경로에 추출합니다. 이 예에서는 `/opt/netbox`를 사용합니다.

최신 버전을 다운로드하고 추출합니다:

```no-highlight
# $NEWVER를 설치할 NetBox 버전으로 설정
NEWVER=3.5.0
wget https://github.com/netbox-community/netbox/archive/v$NEWVER.tar.gz
sudo tar -xzf v$NEWVER.tar.gz -C /opt
sudo ln -sfn /opt/netbox-$NEWVER/ /opt/netbox
```

현재 설치에서 새 버전으로 `local_requirements.txt`, `configuration.py`, `ldap_config.py`(있는 경우)를 복사합니다:

```no-highlight
# $OLDVER를 현재 설치된 NetBox 버전으로 설정
OLDVER=3.4.9
sudo cp /opt/netbox-$OLDVER/local_requirements.txt /opt/netbox/
sudo cp /opt/netbox-$OLDVER/netbox/netbox/configuration.py /opt/netbox/netbox/netbox/
sudo cp /opt/netbox-$OLDVER/netbox/netbox/ldap_config.py /opt/netbox/netbox/netbox/
```

업로드된 미디어도 복제하세요. (필요한 정확한 작업은 미디어를 저장하는 위치에 따라 다르지만 일반적으로 미디어 디렉토리를 이동하거나 복사하면 됩니다.)

```no-highlight
sudo cp -pr /opt/netbox-$OLDVER/netbox/media/ /opt/netbox/netbox/
```

또한 생성한 커스텀 스크립트와 리포트도 복사하거나 링크하세요. 이러한 항목이 프로젝트 루트 외부에 저장된 경우 복사할 필요가 없습니다. (확실하지 않은 경우 위 구성 파일의 `SCRIPTS_ROOT` 및 `REPORTS_ROOT` 매개변수를 확인하세요.)

```no-highlight
sudo cp -r /opt/netbox-$OLDVER/netbox/scripts /opt/netbox/netbox/
sudo cp -r /opt/netbox-$OLDVER/netbox/reports /opt/netbox/netbox/
```

원래 설치 가이드를 따라 gunicorn을 설정한 경우 해당 구성도 복사하세요:

```no-highlight
sudo cp /opt/netbox-$OLDVER/gunicorn.py /opt/netbox/
```

### 옵션 B: Git 릴리스 체크아웃

이 가이드는 NetBox가 `/opt/netbox`에 설치되어 있다고 가정합니다. 먼저 [릴리스 페이지](https://github.com/netbox-community/netbox/releases)를 방문하거나 다음 명령을 실행하여 최신 릴리스를 확인합니다:

```
git ls-remote --tags https://github.com/netbox-community/netbox.git \
  | grep -o 'refs/tags/v[0-9]*\.[0-9]*\.[0-9]*$' \
  | tail -n 1 \
  | sed 's|refs/tags/||'
```

태그를 지정하여 원하는 릴리스를 체크아웃합니다. 예:

```
cd /opt/netbox && \
sudo git fetch --tags && \
sudo git checkout v4.2.7
```

## 4. 업그레이드 스크립트 실행

새 코드가 준비되면 배포에 필요한 선택적 Python 패키지(예: `django-auth-ldap`)가 `local_requirements.txt`에 나열되어 있는지 확인합니다. 그런 다음 업그레이드 스크립트를 실행합니다:

```no-highlight
sudo ./upgrade.sh
```

!!! warning
    기본 Python 버전이 3.10 이상이 아닌 경우 업그레이드 스크립트를 호출할 때 환경 변수로 지원되는 Python 버전의 경로를 전달해야 합니다. 예:

    ```no-highlight
    sudo PYTHON=/usr/bin/python3.10 ./upgrade.sh
    ```

!!! note
    읽기 전용 모드로 데이터베이스에 연결된 노드에서 스크립트를 실행하려면 `--readonly` 매개변수를 포함하세요. 이렇게 하면 데이터베이스 마이그레이션 적용을 건너뜁니다.

이 스크립트는 다음 작업을 수행합니다:

* Python 가상 환경을 파괴하고 다시 빌드
* 모든 필수 Python 패키지 설치(`requirements.txt`에 나열됨)
* `local_requirements.txt`에서 추가 패키지 설치
* 릴리스에 포함된 데이터베이스 마이그레이션 적용
* 문서를 로컬로 빌드(오프라인 사용)
* HTTP 서비스에서 제공할 모든 정적 파일 수집
* 데이터베이스에서 오래된 콘텐츠 타입 삭제
* 데이터베이스에서 만료된 모든 사용자 세션 삭제

!!! note
    업그레이드 스크립트가 반영되지 않은 데이터베이스 마이그레이션에 대한 경고를 표시하면 로컬 코드베이스에 일부 변경이 이루어졌음을 나타내며 조사해야 합니다. 데이터베이스 스키마를 의도적으로 수정하지 않는 한 새 마이그레이션을 만들려고 시도하지 마세요.

## 5. NetBox 서비스 다시 시작

!!! warning
    Python 가상 환경을 사용하지 않는 설치(v2.7.9 이전 릴리스)에서 업그레이드하는 경우 서비스를 다시 시작하기 전에 새로운 Python 및 gunicorn 실행 파일을 참조하도록 systemd 서비스 파일을 업데이트해야 합니다. 이러한 파일은 `/opt/netbox/venv/bin/`에 있습니다. 참조용 예제 서비스 파일은 `/opt/netbox/contrib/`를 참조하세요.

마지막으로 gunicorn 및 RQ 서비스를 다시 시작합니다:

```no-highlight
sudo systemctl restart netbox netbox-rq
```
