# 오류 보고 설정

## SENTRY_CONFIG

`sentry_sdk.init()`에 전달될 키워드 인수를 값에 매핑하는 딕셔너리입니다. 지원되는 매개변수에 대한 자세한 내용은 [Sentry Python SDK 문서](https://docs.sentry.io/platforms/python/)를 참조하세요.

기본 구성은 다음과 같습니다:

```python
{
    "sample_rate": 1.0,
    "send_default_pii": False,
    "traces_sample_rate": 0,
}
```

또한 `http_proxy` 및 `https_proxy`는 각각 NetBox에 대해 구성된 HTTP 및 HTTPS 프록시(있는 경우)로 설정됩니다.

## SENTRY_DSN

!!! warning "이 매개변수는 NetBox v4.5에서 제거될 예정입니다."
    대신 `SENTRY_CONFIG`를 사용하여 설정하세요:

    ```
    SENTRY_CONFIG = {
        "dsn": "https://examplePublicKey@o0.ingest.sentry.io/0",
    }
    ```

기본값: `None`

자동 오류 보고를 위한 Sentry 데이터 소스 이름(DSN)을 정의합니다. 이 매개변수가 적용되려면 `SENTRY_ENABLED`가 `True`여야 합니다. 예:

```
SENTRY_DSN = "https://examplePublicKey@o0.ingest.sentry.io/0"
```

---

## SENTRY_ENABLED

기본값: `False`

[Sentry](https://sentry.io/)를 통한 자동 오류 보고를 활성화하려면 `True`로 설정하세요.

!!! note
    Sentry 통합을 활성화하려면 `sentry-sdk` Python 패키지가 필요합니다.

---

## SENTRY_SAMPLE_RATE

!!! warning "이 매개변수는 NetBox v4.5에서 제거될 예정입니다."
    대신 `SENTRY_CONFIG`를 사용하여 설정하세요:

    ```
    SENTRY_CONFIG = {
        "sample_rate": 0.2,
    }
    ```

기본값: `1.0` (전체)

오류에 대한 샘플링 비율입니다. 0(비활성화)에서 1.0(모든 오류에 대해 보고) 사이의 값이어야 합니다.

---

## SENTRY_SEND_DEFAULT_PII

!!! warning "이 매개변수는 NetBox v4.5에서 제거될 예정입니다."
    대신 `SENTRY_CONFIG`를 사용하여 설정하세요:

    ```
    SENTRY_CONFIG = {
        "send_default_pii": True,
    }
    ```

기본값: `False`

Sentry SDK의 [`send_default_pii`](https://docs.sentry.io/platforms/python/configuration/options/#send-default-pii) 매개변수에 매핑됩니다. 활성화하면 특정 개인 식별 정보(PII)가 추가됩니다.

!!! warning "민감한 데이터"
    이 옵션을 활성화하면 쿠키 및 인증 토큰과 같은 민감한 데이터가 기록됩니다.

---

## SENTRY_TAGS

Sentry 오류 보고서에 적용할 태그 이름과 값의 선택적 딕셔너리입니다. 예:

```
SENTRY_TAGS = {
    "custom.foo": "123",
    "custom.bar": "abc",
}
```

!!! warning "예약된 태그 접두사"
    `netbox.`로 시작하는 태그 이름은 NetBox 애플리케이션에서 예약되어 있으므로 사용하지 마세요.

---

## SENTRY_TRACES_SAMPLE_RATE

!!! warning "이 매개변수는 NetBox v4.5에서 제거될 예정입니다."
    대신 `SENTRY_CONFIG`를 사용하여 설정하세요:

    ```
    SENTRY_CONFIG = {
        "traces_sample_rate": 0.2,
    }
    ```

기본값: `0` (비활성화)

트랜잭션에 대한 샘플링 비율입니다. 0(비활성화)에서 1.0(모든 트랜잭션에 대해 보고) 사이의 값이어야 합니다.

!!! warning "성능 영향 고려"
    트랜잭션에 대한 높은 샘플링 비율은 상당한 성능 저하를 초래할 수 있습니다. 트랜잭션 보고가 필요한 경우 10%에서 20%(0.1에서 0.2)의 비교적 낮은 샘플 비율을 사용하는 것이 좋습니다.
