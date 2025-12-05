# Redis 설치

## Redis 설치

[Redis](https://redis.io/)는 NetBox가 캐싱 및 큐잉에 사용하는 인메모리 키-값 저장소입니다. 이 섹션에서는 로컬 Redis 인스턴스의 설치 및 구성을 다룹니다. 이미 Redis 서비스가 있는 경우 [다음 섹션](3-netbox.md)으로 건너뛰세요.

```no-highlight
sudo apt install -y redis-server
```

계속하기 전에 설치된 Redis 버전이 v4.0 이상인지 확인하세요:

```no-highlight
redis-server -v
```

`/etc/redis.conf` 또는 `/etc/redis/redis.conf`에서 Redis 구성을 수정할 수 있지만, 대부분의 경우 기본 구성으로 충분합니다.

## 서비스 상태 확인

`redis-cli` 유틸리티를 사용하여 Redis 서비스가 정상 작동하는지 확인하세요:

```no-highlight
redis-cli ping
```

성공하면 서버에서 `PONG` 응답을 받게 됩니다.
