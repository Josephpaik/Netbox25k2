# 동기화된 데이터

일부 NetBox 모델은 GitHub 또는 GitLab에 호스팅된 git 저장소와 같은 원격 [데이터 소스](../models/core/datasource.md)에서 특정 속성의 자동 동기화를 지원합니다. 신뢰할 수 있는 원격 소스의 데이터는 NetBox에서 [데이터 파일](../models/core/datafile.md)로 로컬에 동기화됩니다.

!!! note "권한"
    사용자가 원격 데이터 소스에서 로컬 파일을 동기화하려면 `core.sync_datasource` 권한이 할당되어야 합니다. 이는 "Core > Data Source" 객체 유형에 대해 `sync` 작업이 포함된 권한을 생성하고 원하는 사용자 및/또는 그룹에 할당하여 수행합니다.

다음 기능은 동기화된 데이터 사용을 지원합니다:

* [구성 템플릿](../features/configuration-rendering.md)
* [구성 컨텍스트 데이터](../features/context-data.md)
* [내보내기 템플릿](../customization/export-templates.md)
