# 원격 인증 설정

여기에 나열된 구성 매개변수는 NetBox의 원격 인증을 제어합니다. 이러한 설정이 적용되려면 `REMOTE_AUTH_ENABLED`가 `True`여야 합니다.

---

## REMOTE_AUTH_AUTO_CREATE_GROUPS

기본값: `False`

`True`인 경우 NetBox는 `REMOTE_AUTH_GROUP_HEADER` 헤더에 지정된 그룹이 아직 존재하지 않으면 자동으로 생성합니다. (`REMOTE_AUTH_ENABLED` 필요.)

---

## REMOTE_AUTH_AUTO_CREATE_USER

기본값: `False`

`True`인 경우 NetBox는 원격 서비스를 통해 인증된 사용자에 대해 자동으로 로컬 계정을 생성합니다. (`REMOTE_AUTH_ENABLED` 필요.)

---

## REMOTE_AUTH_BACKEND

기본값: `'netbox.authentication.RemoteUserBackend'`

외부 사용자 인증에 사용할 사용자 정의 [Django 인증 백엔드](https://docs.djangoproject.com/en/stable/topics/auth/customizing/)에 대한 Python 경로입니다. NetBox는 두 가지 내장 백엔드(아래 나열)를 제공하지만, 다른 패키지나 플러그인에서도 사용자 정의 인증 백엔드를 제공할 수 있습니다. 단일 백엔드의 경우 문자열을, 여러 백엔드의 경우 반복 가능 객체를 제공하면 지정된 순서대로 시도됩니다.

* `netbox.authentication.RemoteUserBackend`
* `netbox.authentication.LDAPBackend`

---

## REMOTE_AUTH_DEFAULT_GROUPS

기본값: `[]` (빈 목록)

원격 인증을 사용하여 새 사용자 계정을 생성할 때 할당할 그룹 목록입니다. (`REMOTE_AUTH_ENABLED` 필요.)

---

## REMOTE_AUTH_DEFAULT_PERMISSIONS

기본값: `{}` (빈 딕셔너리)

원격 인증을 사용하여 새 사용자 계정을 생성할 때 할당할 권한 매핑입니다. 딕셔너리의 각 키는 권한에 적용할 속성의 딕셔너리로 설정하거나 모든 객체를 허용하려면 `None`으로 설정해야 합니다. (`REMOTE_AUTH_ENABLED`가 `True`이고 `REMOTE_AUTH_GROUP_SYNC_ENABLED`가 `False`여야 함.)

---

## REMOTE_AUTH_ENABLED

기본값: `False`

NetBox는 HTTP 역방향 프록시(예: nginx 또는 Apache)가 설정한 HTTP 헤더에서 사용자 인증을 추론하여 원격 사용자 인증을 지원하도록 구성할 수 있습니다. 이 기능을 활성화하려면 `True`로 설정하세요. (로컬 인증은 여전히 대체 수단으로 작동합니다.) (`REMOTE_AUTH_ENABLED`가 비활성화되면 `REMOTE_AUTH_DEFAULT_GROUPS`가 작동하지 않습니다)

---

## REMOTE_AUTH_GROUP_HEADER

기본값: `'HTTP_REMOTE_USER_GROUP'`

원격 사용자 인증을 사용할 때 NetBox에 현재 인증된 사용자를 알려주는 HTTP 헤더의 이름입니다. 예를 들어, 요청 헤더 `X-Remote-User-Groups`를 사용하려면 `HTTP_X_REMOTE_USER_GROUPS`로 설정해야 합니다. (`REMOTE_AUTH_ENABLED` 및 `REMOTE_AUTH_GROUP_SYNC_ENABLED` 필요)

---

## REMOTE_AUTH_GROUP_SEPARATOR

기본값: `|` (파이프)

`REMOTE_AUTH_GROUP_HEADER`가 개별 그룹으로 분할되는 구분 기호입니다. 이는 인증 프록시와 조정되어야 합니다. (`REMOTE_AUTH_ENABLED` 및 `REMOTE_AUTH_GROUP_SYNC_ENABLED` 필요)

---

## REMOTE_AUTH_GROUP_SYNC_ENABLED

기본값: `False`

NetBox는 HTTP 역방향 프록시(예: nginx 또는 Apache)가 설정한 HTTP 헤더에서 사용자 인증을 추론하여 원격 사용자 그룹을 동기화하도록 구성할 수 있습니다. 이 기능을 활성화하려면 `True`로 설정하세요. (로컬 인증은 여전히 대체 수단으로 작동합니다.) (`REMOTE_AUTH_ENABLED` 필요.)

---

## REMOTE_AUTH_HEADER

기본값: `'HTTP_REMOTE_USER'`

원격 사용자 인증을 사용할 때 NetBox에 현재 인증된 사용자를 알려주는 HTTP 헤더의 이름입니다. 예를 들어, 요청 헤더 `X-Remote-User`를 사용하려면 `HTTP_X_REMOTE_USER`로 설정해야 합니다. (`REMOTE_AUTH_ENABLED` 필요.)

!!! warning 헤더 호환성 확인
    일부 WSGI 서버는 지원되지 않는 문자가 포함된 헤더를 삭제할 수 있습니다. 예를 들어, gunicorn v22.0 이상은 밑줄이 포함된 HTTP 헤더를 자동으로 삭제합니다. 이 동작은 gunicorn의 [`header_map`](https://docs.gunicorn.org/en/stable/settings.html#header-map) 설정을 `dangerous`로 변경하여 비활성화할 수 있습니다.

---

## REMOTE_AUTH_USER_EMAIL

기본값: `'HTTP_REMOTE_USER_EMAIL'`

원격 사용자 인증을 사용할 때 NetBox에 현재 인증된 사용자의 이메일 주소를 알려주는 HTTP 헤더의 이름입니다. 예를 들어, 요청 헤더 `X-Remote-User-Email`을 사용하려면 `HTTP_X_REMOTE_USER_EMAIL`로 설정해야 합니다. (`REMOTE_AUTH_ENABLED` 필요.)

---

## REMOTE_AUTH_USER_FIRST_NAME

기본값: `'HTTP_REMOTE_USER_FIRST_NAME'`

원격 사용자 인증을 사용할 때 NetBox에 현재 인증된 사용자의 이름을 알려주는 HTTP 헤더의 이름입니다. 예를 들어, 요청 헤더 `X-Remote-User-First-Name`을 사용하려면 `HTTP_X_REMOTE_USER_FIRST_NAME`으로 설정해야 합니다. (`REMOTE_AUTH_ENABLED` 필요.)

---

## REMOTE_AUTH_USER_LAST_NAME

기본값: `'HTTP_REMOTE_USER_LAST_NAME'`

원격 사용자 인증을 사용할 때 NetBox에 현재 인증된 사용자의 성을 알려주는 HTTP 헤더의 이름입니다. 예를 들어, 요청 헤더 `X-Remote-User-Last-Name`을 사용하려면 `HTTP_X_REMOTE_USER_LAST_NAME`으로 설정해야 합니다. (`REMOTE_AUTH_ENABLED` 필요.)

---

## REMOTE_AUTH_SUPERUSER_GROUPS

기본값: `[]` (빈 목록)

로그인 시 원격 사용자를 슈퍼유저로 승격시키는 그룹 목록입니다. 다음 로그인 시 그룹이 없으면 역할이 취소됩니다. (`REMOTE_AUTH_ENABLED` 및 `REMOTE_AUTH_GROUP_SYNC_ENABLED` 필요)

---

## REMOTE_AUTH_SUPERUSERS

기본값: `[]` (빈 목록)

로그인 시 슈퍼유저로 승격되는 사용자 목록입니다. 다음 로그인 시 사용자가 목록에 없으면 역할이 취소됩니다. (`REMOTE_AUTH_ENABLED` 및 `REMOTE_AUTH_GROUP_SYNC_ENABLED` 필요)

---

## REMOTE_AUTH_STAFF_GROUPS

기본값: `[]` (빈 목록)

로그인 시 원격 사용자를 스태프로 승격시키는 그룹 목록입니다. 다음 로그인 시 그룹이 없으면 역할이 취소됩니다. (`REMOTE_AUTH_ENABLED` 및 `REMOTE_AUTH_GROUP_SYNC_ENABLED` 필요)

---

## REMOTE_AUTH_STAFF_USERS

기본값: `[]` (빈 목록)

로그인 시 스태프로 승격되는 사용자 목록입니다. 다음 로그인 시 사용자가 목록에 없으면 역할이 취소됩니다. (`REMOTE_AUTH_ENABLED` 및 `REMOTE_AUTH_GROUP_SYNC_ENABLED` 필요)
