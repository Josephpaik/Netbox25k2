# 내보내기 템플릿

NetBox에서는 사용자가 객체를 내보낼 때 사용할 수 있는 사용자 정의 템플릿을 정의할 수 있습니다. 내보내기 템플릿을 만들려면 Customization > Export Templates로 이동합니다.

각 내보내기 템플릿은 특정 유형의 객체와 연결됩니다. 예를 들어, VLAN에 대한 내보내기 템플릿을 만들면 VLAN 목록의 "Export" 버튼 아래에 사용자 정의 템플릿이 표시됩니다. 각 내보내기 템플릿에는 이름이 있어야 하며, 선택적으로 특정 내보내기 [MIME 유형](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types) 및/또는 파일 확장자를 지정할 수 있습니다.

내보내기 템플릿은 [Jinja2](https://jinja.palletsprojects.com/)로 작성해야 합니다.

!!! note
    `table`이라는 이름은 내부 사용을 위해 예약되어 있습니다.

!!! warning
    내보내기 템플릿은 사용자가 제출한 코드를 사용하여 렌더링되므로 특정 조건에서 보안 위험을 초래할 수 있습니다. 신뢰할 수 있는 사용자에게만 내보내기 템플릿을 만들거나 수정할 수 있는 권한을 부여하세요.

내보내기 템플릿을 렌더링할 때 데이터베이스에서 반환되는 객체 목록은 `queryset` 변수에 저장되며, 일반적으로 `for` 루프를 사용하여 반복합니다. 객체 속성은 이름으로 접근할 수 있습니다. 예:

```jinja2
{% for rack in queryset %}
Rack: {{ rack.name }}
Site: {{ rack.site.name }}
Height: {{ rack.u_height }}U
{% endfor %}
```

템플릿 내에서 객체의 사용자 정의 필드에 접근하려면 `cf` 속성을 사용합니다. 예를 들어, `{{ obj.cf.color }}`는 `obj`에 대한 `color`라는 사용자 정의 필드의 값(있는 경우)을 반환합니다.

내보내기 템플릿에서 구성 컨텍스트 데이터를 사용해야 하는 경우 `get_config_context` 함수를 사용하여 모든 구성 컨텍스트 데이터를 가져와야 합니다. 예:

```
{% for server in queryset %}
{% set data = server.get_config_context() %}
{{ data.syslog }}
{% endfor %}
```

내보내기 템플릿의 `as_attachment` 속성은 렌더링될 때의 동작을 제어합니다. true이면 렌더링된 콘텐츠가 다운로드 가능한 파일로 사용자에게 반환됩니다. false이면 브라우저 내에서 표시됩니다. (예를 들어 HTML 콘텐츠를 생성하는 데 유용할 수 있습니다.)

각 내보내기 템플릿에 대해 MIME 유형과 파일 확장자를 선택적으로 정의할 수 있습니다. 기본 MIME 유형은 `text/plain`입니다.

## REST API 통합

인증 자격 증명을 제공해야 하는 경우(예: [`LOGIN_REQUIRED`](../configuration/security.md#login_required)가 활성화된 경우), REST API를 통해 내보내기 템플릿을 렌더링하는 것이 좋습니다. 이렇게 하면 클라이언트가 인증 토큰을 지정할 수 있습니다. REST API를 통해 내보내기 템플릿을 렌더링하려면 모델의 목록 엔드포인트에 `GET` 요청을 수행하고 내보내기 템플릿 이름을 지정하는 `export` 매개변수를 추가합니다. 예:

```
GET /api/dcim/sites/?export=MyTemplateName
```

응답 본문에는 JSON 객체 또는 목록이 아닌 렌더링된 내보내기 템플릿 콘텐츠만 포함됩니다.

## 예제

다음은 장비 목록에서 간단한 Nagios 구성을 생성하는 예제 장비 내보내기 템플릿입니다.

```
{% for device in queryset %}{% if device.status and device.primary_ip %}define host{
        use                     generic-switch
        host_name               {{ device.name }}
        address                 {{ device.primary_ip.address.ip }}
}
{% endif %}{% endfor %}
```

생성된 출력은 다음과 같습니다:

```
define host{
        use                     generic-switch
        host_name               switch1
        address                 192.0.2.1
}
define host{
        use                     generic-switch
        host_name               switch2
        address                 192.0.2.2
}
define host{
        use                     generic-switch
        host_name               switch3
        address                 192.0.2.3
}
```
