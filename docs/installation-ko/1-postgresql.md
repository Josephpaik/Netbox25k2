# PostgreSQL 데이터베이스 설치

이 섹션에서는 로컬 PostgreSQL 데이터베이스의 설치 및 구성을 다룹니다. 이미 PostgreSQL 데이터베이스 서비스가 있는 경우 [다음 섹션](2-redis.md)으로 건너뛰세요.

!!! warning "PostgreSQL 14 이상 필요"
    NetBox는 PostgreSQL 14 이상이 필요합니다. MySQL 및 기타 관계형 데이터베이스는 **지원되지 않습니다**.

## 설치

```no-highlight
sudo apt update
sudo apt install -y postgresql
```

계속하기 전에 PostgreSQL 14 이상을 설치했는지 확인하세요:

```no-highlight
psql -V
```

## 데이터베이스 생성

최소한 NetBox용 데이터베이스를 생성하고 인증을 위한 사용자 이름과 비밀번호를 할당해야 합니다. 시스템 Postgres 사용자로 PostgreSQL 셸을 호출하여 시작하세요.

```no-highlight
sudo -u postgres psql
```

셸 내에서 다음 명령을 입력하여 데이터베이스와 사용자(역할)를 생성하고, 비밀번호에는 자신의 값을 대입하세요:

```postgresql
CREATE DATABASE netbox;
CREATE USER netbox WITH PASSWORD 'J5brHrAXFLQSif0K';
ALTER DATABASE netbox OWNER TO netbox;
-- 다음 두 명령은 PostgreSQL 15 이상에서 필요합니다
\connect netbox;
GRANT CREATE ON SCHEMA public TO netbox;
```

!!! danger "강력한 비밀번호 사용"
    **예제의 비밀번호를 사용하지 마세요.** NetBox 설치를 위한 안전한 데이터베이스 인증을 보장하기 위해 강력하고 무작위인 비밀번호를 선택하세요.

!!! danger "UTF8 인코딩 사용"
    데이터베이스가 `UTF8` 인코딩을 사용하는지 확인하세요(새 설치의 기본값). 특히 예측 불가능하고 복구 불가능한 오류를 초래할 수 있는 `SQL_ASCII` 인코딩은 사용하지 마세요. `\l`을 입력하여 인코딩을 확인할 수 있습니다.

완료되면 `\q`를 입력하여 PostgreSQL 셸을 종료합니다.

## 서비스 상태 확인

구성된 사용자 이름과 비밀번호를 전달하여 `psql` 명령을 실행하면 인증이 작동하는지 확인할 수 있습니다. (원격 데이터베이스를 사용하는 경우 `localhost`를 데이터베이스 서버로 교체하세요.)

```no-highlight
$ psql --username netbox --password --host localhost netbox
Password for user netbox:
psql (12.5 (Ubuntu 12.5-0ubuntu0.20.04.1))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
Type "help" for help.

netbox=> \conninfo
You are connected to database "netbox" as user "netbox" on host "localhost" (address "127.0.0.1") at port "5432".
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
netbox=> \q
```

성공하면 `netbox` 프롬프트가 표시됩니다. `\conninfo`를 입력하여 연결을 확인하거나 `\q`를 입력하여 종료하세요.
