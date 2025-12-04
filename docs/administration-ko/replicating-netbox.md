# NetBox 복제

## 데이터베이스 복제

NetBox는 [PostgreSQL](https://www.postgresql.org/) 데이터베이스를 사용하므로 일반적인 PostgreSQL 모범 사례가 여기에 적용됩니다. 데이터베이스는 각각 `pg_dump` 및 `psql` 유틸리티를 사용하여 파일에 쓰고 복원할 수 있습니다.

!!! note
    아래 예제는 데이터베이스 이름이 `netbox`라고 가정합니다.

### 데이터베이스 내보내기

`pg_dump` 유틸리티를 사용하여 전체 데이터베이스를 파일로 내보냅니다:

```no-highlight
pg_dump --username netbox --password --host localhost netbox > netbox.sql
```

!!! note
    설치에 맞게 위 명령에서 사용자 이름, 호스트 및/또는 데이터베이스를 변경해야 할 수 있습니다.

개발 목적으로 프로덕션 데이터베이스를 복제할 때 데이터베이스 크기의 대부분을 차지할 수 있는 변경 로그 데이터를 제외하면 편리할 수 있습니다. 이렇게 하려면 내보내기에서 `core_objectchange` 테이블 데이터를 제외합니다. 테이블은 여전히 출력 파일에 포함되지만 데이터로 채워지지 않습니다.

```no-highlight
pg_dump ... --exclude-table-data=core_objectchange netbox > netbox.sql
```

### 내보낸 데이터베이스 로드

파일에서 데이터베이스를 복원할 때 잠재적인 충돌을 피하기 위해 먼저 기존 데이터베이스를 삭제하는 것이 좋습니다.

!!! warning
    다음은 데이터베이스의 기존 인스턴스를 삭제하고 교체합니다.

```no-highlight
psql -c 'drop database netbox'
psql -c 'create database netbox'
psql netbox < netbox.sql
```

PostgreSQL 사용자 계정과 권한은 덤프에 포함되지 않으므로 원래 데이터베이스를 완전히 복제하려면 수동으로 생성해야 합니다([설치 문서](../installation/1-postgresql.md) 참조). NetBox 개발 인스턴스를 설정할 때는 어쨌든 다른 자격 증명을 사용하는 것이 강력히 권장됩니다.

### 데이터베이스 스키마 내보내기

데이터 자체가 아닌 데이터베이스 스키마만 내보내려면(예: 개발 참조용) 다음을 수행합니다:

```no-highlight
pg_dump --username netbox --password --host localhost -s netbox > netbox_schema.sql
```

---

## 업로드된 미디어 복제

기본적으로 NetBox는 업로드된 파일(예: 이미지 첨부 파일)을 미디어 디렉토리에 저장합니다. NetBox 인스턴스를 완전히 복제하려면 데이터베이스와 미디어 파일을 모두 복사해야 합니다.

!!! note
    설치에서 [원격 스토리지 백엔드](../configuration/system.md#storages)를 사용하는 경우 이러한 작업이 필요하지 않습니다.

### 미디어 디렉토리 아카이브

NetBox 설치 경로의 루트(일반적으로 `/opt/netbox`)에서 다음 명령을 실행합니다:

```no-highlight
tar -czf netbox_media.tar.gz netbox/media/
```

### 미디어 디렉토리 복원

저장된 아카이브를 새 설치에 추출하려면 설치 루트에서 다음을 실행합니다:

```no-highlight
tar -xf netbox_media.tar.gz
```
