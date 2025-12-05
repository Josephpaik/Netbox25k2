# NetBox 보고서

!!! warning
    보고서는 NetBox v4.0부터 더 이상 사용되지 않으며, 해당 기능은 [사용자 정의 스크립트](./custom-scripts.md)에 병합되었습니다. 하위 호환성이 유지되었지만, 레거시 보고서에 대한 지원이 향후 릴리스에서 제거될 예정이므로 사용자는 가능한 빨리 레거시 보고서를 사용자 정의 스크립트로 변환하는 것이 좋습니다.

## 보고서를 스크립트로 변환

### 1단계: 클래스 정의 업데이트

부모 클래스를 `Report`에서 `Script`로 변경합니다:

```python title="이전 코드"
from extras.reports import Report

class MyReport(Report):
```

```python title="새 코드"
from extras.scripts import Script

class MyReport(Script):
```

### 2단계: 로깅 호출 업데이트

보고서와 스크립트 모두 로깅 메서드를 제공하지만 시그니처가 다릅니다. 모든 스크립트 로깅 메서드는 첫 번째 매개변수로 메시지를 받고, 두 번째 매개변수로 객체를 선택적으로 받습니다.

또한 Report 클래스의 일반 `log()` 메서드는 Script에서 사용할 수 **없습니다**. 사용자는 이 메서드의 호출을 `log_info()`로 대체하는 것이 좋습니다.

이러한 메서드를 업데이트할 때 아래 표를 참조로 사용하세요.

| Report (이전) | Script (새) |
|---------------|-------------|
| `log(message)` | `log_info(message)` |
| `log_debug(obj, message)`[^1] | `log_debug(message, obj)` |
| `log_info(obj, message)` | `log_info(message, obj)` |
| `log_success(obj, message)` | `log_success(message, obj)` |
| `log_warning(obj, message)` | `log_warning(message, obj)` |
| `log_failure(obj, message)` | `log_failure(message, obj)` |

[^1]: `log_debug()`는 Script와 동일한 메서드와의 혼동을 피하기 위해 v4.0에서 Report 클래스에 추가되었습니다.

```python title="이전 코드"
self.log_failure(
    console_port.device,
    f"No console connection defined for {console_port.name}"
)
```

```python title="새 코드"
self.log_failure(
    f"No console connection defined for {console_port.name}",
    obj=console_port.device,
)
```

### 기타 참고 사항

기존 보고서는 NetBox v4.0으로 업그레이드할 때 자동으로 스크립트로 변환되며, 이전 작업 기록이 유지됩니다. 그러나 레거시 보고서에 대한 지원이 향후 릴리스에서 제거될 예정이므로 가능한 빨리 레거시 보고서를 사용자 정의 스크립트로 변환하는 것이 좋습니다.

Report의 `pre_run()` 및 `post_run()` 메서드는 Script로 이전되었습니다. 이들은 Script의 `run()` 메서드에 의해 자동으로 호출됩니다. (이 메서드를 재정의하는 경우 해당하는 곳에서 `pre_run()` 및 `post_run()`을 호출하는 것은 사용자의 책임입니다.)

Report의 `is_valid()` 메서드는 더 이상 필요하지 않으며 제거되었습니다.
