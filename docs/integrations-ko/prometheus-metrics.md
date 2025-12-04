# Prometheus 메트릭

NetBox는 애플리케이션에서 선택적으로 네이티브 Prometheus 메트릭을 노출하는 것을 지원합니다. [Prometheus](https://prometheus.io/)는 모니터링에 사용되는 인기 있는 시계열 메트릭 플랫폼입니다.

NetBox는 `/metrics` HTTP 엔드포인트(예: `https://netbox.local/metrics`)에서 메트릭을 노출합니다. 메트릭 노출은 `METRICS_ENABLED` 구성 설정으로 전환할 수 있습니다. 메트릭은 기본적으로 노출되지 않습니다.

## 메트릭 유형

NetBox는 [django-prometheus](https://github.com/korfuri/django-prometheus) 라이브러리를 사용하여 다음을 포함한 다양한 유형의 메트릭을 내보냅니다:

- 모델별 삽입, 업데이트 및 삭제 카운터
- 뷰별 요청 카운터
- 뷰별 요청 지연 히스토그램
- REST API 요청 (엔드포인트 및 메서드별)
- GraphQL API 요청
- 요청 본문 크기 히스토그램
- 응답 본문 크기 히스토그램
- 응답 코드 카운터
- 데이터베이스 연결, 실행 및 오류 카운터
- 캐시 히트, 미스 및 무효화 카운터
- Django 미들웨어 지연 히스토그램
- 기타 Django 관련 메타데이터 메트릭

노출된 메트릭의 전체 목록을 보려면 NetBox 인스턴스의 `/metrics` 엔드포인트를 방문하세요.

## 멀티 프로세싱 참고 사항

NetBox를 멀티프로세스 방식으로 배포할 때(예: 여러 Gunicorn 워커 실행) Prometheus 클라이언트 라이브러리는 모든 워커 프로세스에서 메트릭을 수집하기 위해 공유 디렉토리를 사용해야 합니다. 이를 구성하려면 먼저 워커 프로세스가 읽기 및 쓰기 권한을 가진 로컬 디렉토리를 생성하거나 지정한 다음, WSGI 서비스(예: Gunicorn)에서 이 경로를 `prometheus_multiproc_dir` 환경 변수로 정의하도록 구성합니다.

!!! warning
    멀티프로세스 환경에서 정확한 장기 메트릭이 배포에 중요한 경우 `gunicorn` 대신 `uwsgi` 라이브러리를 사용하는 것이 좋습니다. 문제는 위 구성에서 생성된 메트릭 파일을 관리하는 데 도움이 되는 워커 프로세스를 추적하는 방식에서 `gunicorn`이 `uwsgi`와 다르다는 것입니다. 컨테이너당 하나의 프로세스 방법론을 따르는 컨테이너화된 환경에서 gunicorn과 함께 NetBox를 사용하는 경우 `uwsgi`로 변경할 필요가 없을 수 있습니다. 자세한 내용은 [이슈 #3779](https://github.com/netbox-community/netbox/issues/3779#issuecomment-590547562)에서 확인할 수 있습니다.
