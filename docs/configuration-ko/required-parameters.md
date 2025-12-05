# 필수 구성 설정

## ALLOWED_HOSTS

이것은 NetBox 서비스에 접근하는 데 사용할 수 있는 유효한 정규화된 도메인 이름(FQDN) 및/또는 IP 주소 목록입니다. 일반적으로 이것은 NetBox 서버의 호스트 이름과 동일하지만, 다를 수도 있습니다. 예를 들어, NetBox 서버의 호스트 이름과 다른 FQDN으로 NetBox 웹사이트를 제공하는 역방향 프록시를 사용할 때입니다. [HTTP Host 헤더 공격](https://docs.djangoproject.com/en/stable/topics/security/#host-headers-virtual-hosting)을 방지하기 위해 NetBox는 다른 호스트 이름(또는 IP)을 통한 서버 접근을 허용하지 않습니다.

!!! note
    이 매개변수는 단일 값만 제공되더라도 항상 목록 또는 튜플로 정의해야 합니다.

이 옵션의 값은 `CSRF_TRUSTED_ORIGINS` 설정에도 사용되며, POST 요청을 동일한 호스트 집합으로 제한합니다(자세한 내용은 [여기](https://docs.djangoproject.com/en/stable/ref/settings/#std:setting-CSRF_TRUSTED_ORIGINS)를 참조하세요). NetBox는 기본적으로 `USE_X_FORWARDED_HOST`를 `True`로 설정하므로, 역방향 프록시를 사용하는 경우 해당 역방향 프록시에 도달하는 데 사용되는 FQDN이 이 목록에 있어야 합니다(자세한 내용은 [여기](https://docs.djangoproject.com/en/stable/ref/settings/#allowed-hosts)를 참조하세요).

예:

```
ALLOWED_HOSTS = ['netbox.example.com', '192.0.2.123']
```

NetBox 설치의 도메인 이름 및/또는 IP 주소가 아직 확실하지 않고 그로 인한 위험을 감수할 수 있다면, 와일드카드(별표)를 설정하여 모든 호스트 값을 허용할 수 있습니다:

```
ALLOWED_HOSTS = ['*']
```

---

## DATABASE

!!! warning "레거시 구성 매개변수"
    `DATABASE` 구성 매개변수는 더 이상 사용되지 않으며 향후 릴리스에서 제거될 예정입니다. 사용자는 여러 데이터베이스 구성을 허용하는 새로운 `DATABASES`(복수형) 매개변수를 채택하는 것이 좋습니다.

사용법은 아래의 [`DATABASES`](#databases) 구성을 참조하세요.

---

## DATABASES

NetBox는 데이터를 저장하기 위해 PostgreSQL 14 이상의 데이터베이스 서비스에 접근해야 합니다. 이 서비스는 NetBox 서버에서 로컬로 실행하거나 원격 시스템에서 실행할 수 있습니다. 데이터베이스는 명명된 딕셔너리로 정의됩니다:

```python
DATABASES = {
    'default': {...},
    'external1': {...},
    'external2': {...},
}
```

NetBox 자체는 `default` 데이터베이스만 정의하면 됩니다. 그러나 특정 플러그인은 추가 데이터베이스 구성이 필요할 수 있습니다. (여러 데이터베이스를 사용할 때는 [`DATABASE_ROUTERS`](./system.md#database_routers) 매개변수 구성도 고려하세요.)

각 데이터베이스에 대해 다음 매개변수를 정의해야 합니다:

* `NAME` - 데이터베이스 이름
* `USER` - PostgreSQL 사용자 이름
* `PASSWORD` - PostgreSQL 비밀번호
* `HOST` - 데이터베이스 서버의 이름 또는 IP 주소(로컬에서 실행하는 경우 `localhost` 사용)
* `PORT` - PostgreSQL 서비스의 TCP 포트; 기본 포트(TCP/5432)를 사용하려면 비워둠
* `CONN_MAX_AGE` - [영구 데이터베이스 연결](https://docs.djangoproject.com/en/stable/ref/databases/#persistent-connections)의 수명(초 단위, 기본값 300)
* `ENGINE` - 사용할 데이터베이스 백엔드; PostgreSQL 호환 백엔드여야 함(예: `django.db.backends.postgresql`)

예:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'netbox',               # 데이터베이스 이름
        'USER': 'netbox',               # PostgreSQL 사용자 이름
        'PASSWORD': 'J5brHrAXFLQSif0K', # PostgreSQL 비밀번호
        'HOST': 'localhost',            # 데이터베이스 서버
        'PORT': '',                     # 데이터베이스 포트(기본값은 비워둠)
        'CONN_MAX_AGE': 300,            # 최대 데이터베이스 연결 수명
    }
}
```

!!! note
    NetBox는 기본 Django 프레임워크에서 지원하는 모든 PostgreSQL 데이터베이스 옵션을 지원합니다. 사용 가능한 매개변수의 전체 목록은 [Django 문서](https://docs.djangoproject.com/en/stable/ref/settings/#databases)를 참조하세요.

!!! warning
    `ENGINE` 매개변수는 PostgreSQL 호환 데이터베이스 백엔드를 지정해야 합니다. 정의되지 않은 경우 기본 엔진 `django.db.backends.postgresql`이 사용됩니다.

---

## REDIS

[Redis](https://redis.io/)는 memcached와 유사한 경량 인메모리 데이터 저장소입니다. NetBox는 백그라운드 작업 대기열 및 기타 기능에 Redis를 사용합니다.

Redis는 `DATABASE`와 유사한 구성 설정을 사용하여 구성되며 이러한 설정은 `tasks` 및 `caching` 하위 섹션 모두에서 동일합니다:

* `HOST` - Redis 서버의 이름 또는 IP 주소(로컬에서 실행하는 경우 `localhost` 사용)
* `PORT` - Redis 서비스의 TCP 포트; 기본 포트(6379)를 사용하려면 비워둠
* `USERNAME` - Redis 사용자 이름(설정된 경우)
* `PASSWORD` - Redis 비밀번호(설정된 경우)
* `DATABASE` - 숫자 데이터베이스 ID
* `SSL` - Redis에 SSL 연결 사용
* `INSECURE_SKIP_TLS_VERIFY` - TLS 인증서 확인을 **비활성화**하려면 `True`로 설정(권장하지 않음)

예제 구성은 다음과 같습니다:

```python
REDIS = {
    'tasks': {
        'HOST': 'redis.example.com',
        'PORT': 1234,
        'USERNAME': 'netbox',
        'PASSWORD': 'foobar',
        'DATABASE': 0,
        'SSL': False,
    },
    'caching': {
        'HOST': 'localhost',
        'PORT': 6379,
        'USERNAME': '',
        'PASSWORD': '',
        'DATABASE': 1,
        'SSL': False,
    }
}
```

!!! warning
    작업 데이터베이스와 캐시 데이터베이스를 분리하는 것이 좋습니다. 동일한 Redis 인스턴스에서 두 가지 모두에 동일한 데이터베이스 번호를 사용하면 캐시 플러시 이벤트 중에 대기 중인 백그라운드 작업이 손실될 수 있습니다.

### UNIX 소켓 지원

Redis는 개별 구성 요소 대신 전체 URL을 지정하여 구성할 수도 있습니다. 이 방법은 UNIX 소켓 연결 사용을 지원합니다. 예:

```python
REDIS = {
    'tasks': {
        'URL': 'unix:///run/redis-netbox/redis.sock?db=0'
    },
    'caching': {
        'URL': 'unix:///run/redis-netbox/redis.sock?db=1'
    },
}
```

### Redis Sentinel 사용

고가용성 목적으로 [Redis Sentinel](https://redis.io/topics/sentinel)을 사용하는 경우, NetBox가 이를 인식하도록 변환하는 데 필요한 구성은 최소한입니다. 위의 `HOST` 및 `PORT` 키를 제거하고 세 개의 새 키를 추가해야 합니다.

* `SENTINELS`: 연결할 각 Sentinel 인스턴스에 대해 Redis 서버의 이름 또는 IP 주소와 포트를 포함하는 내부 튜플의 튜플 목록 또는 튜플
* `SENTINEL_SERVICE`: 연결할 마스터/서비스 이름
* `SENTINEL_TIMEOUT`: 연결 제한 시간(초)

예:

```python
REDIS = {
    'tasks': {
        'SENTINELS': [('mysentinel.redis.example.com', 6379)],
        'SENTINEL_SERVICE': 'netbox',
        'SENTINEL_TIMEOUT': 10,
        'PASSWORD': '',
        'DATABASE': 0,
        'SSL': False,
    },
    'caching': {
        'SENTINELS': [
            ('mysentinel.redis.example.com', 6379),
            ('othersentinel.redis.example.com', 6379)
        ],
        'SENTINEL_SERVICE': 'netbox',
        'PASSWORD': '',
        'DATABASE': 1,
        'SSL': False,
    }
}
```

!!! note
    하나의 데이터베이스에만 Sentinel을 사용하고 다른 데이터베이스에는 사용하지 않는 것이 허용됩니다.

---

## SECRET_KEY

이것은 비밀번호와 HTTP 쿠키에 대한 새로운 암호화 해시 생성을 지원하는 데 사용되는 비밀 의사 난수 문자열입니다. 여기에 정의된 키는 구성 파일 외부에서 공유해서는 안 됩니다. `SECRET_KEY`는 저장된 데이터에 영향을 주지 않고 언제든지 변경할 수 있지만, 변경하면 모든 기존 사용자 세션이 무효화됩니다. 여러 노드로 구성된 NetBox 배포는 모든 노드에서 동일한 비밀 키를 구성해야 합니다.

`SECRET_KEY`는 최소 50자 이상이어야 하며 문자, 숫자 및 기호를 혼합하여 포함해야 합니다. `$INSTALL_ROOT/netbox/generate_secret_key.py`에 있는 스크립트를 사용하여 적합한 키를 생성할 수 있습니다. 이 키는 사용자 비밀번호 해싱이나 NetBox의 비밀 데이터 암호화 저장에 직접 사용되지 **않습니다**.
