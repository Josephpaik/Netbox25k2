# 오류 보고

## Sentry

### 오류 보고 활성화

NetBox는 자동 오류 보고를 위해 [Sentry](https://sentry.io/)와의 네이티브 통합을 지원합니다. 이 기능을 활성화하려면 `configuration.py`에서 `SENTRY_ENABLED`를 `True`로 설정하고 고유한 [데이터 소스 이름(DSN)](https://docs.sentry.io/product/sentry-basics/concepts/dsn-explainer/)을 정의하세요.

```python
SENTRY_ENABLED = True
SENTRY_DSN = "https://examplePublicKey@o0.ingest.sentry.io/0"
```

`SENTRY_ENABLED`를 False로 설정하면 Sentry 통합이 비활성화됩니다.

### 태그 할당

원하는 경우 `SENTRY_TAGS` 매개변수를 설정하여 발신 오류 보고서에 하나 이상의 임의 태그를 첨부할 수 있습니다:

```python
SENTRY_TAGS = {
    "custom.foo": "123",
    "custom.bar": "abc",
}
```

!!! warning "예약된 태그 접두사"
    `netbox.`로 시작하는 태그 이름은 NetBox 애플리케이션에서 예약되어 있으므로 사용하지 마세요.

### 테스트

구성을 저장한 후 NetBox 서비스를 다시 시작하세요.

Sentry 작동을 테스트하려면 `https://netbox/404-error-testing`과 같은 잘못된 URL로 이동하여 404(페이지를 찾을 수 없음) 오류를 생성해 보세요. (디버그 모드가 비활성화되어 있는지 확인하세요.) NetBox 서버에서 404 응답을 받은 후 곧 Sentry에 이슈가 나타나는 것을 볼 수 있습니다.
