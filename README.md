# emobin

Flutter 모노레포(Feature 패키지 구조)이며 Melos로 공통 의존성 버전과 작업 스크립트를 관리합니다.

## 구조
- `app` (Flutter 앱)
- `packages/feature_counter` (예시 Feature 패키지)

## Melos 설정 위치
- 루트 `pubspec.yaml`의 `melos:` 섹션
- 공통 의존성 버전 관리 위치
- `melos.command.bootstrap.dependencies`
- `melos.command.bootstrap.dev_dependencies`

## 사용법
1. 워크스페이스 부트스트랩
   - `dart run melos bootstrap`
2. 앱 실행
   - `cd app && flutter run`

## 공통 의존성 버전 관리
1. 여러 패키지에서 공통으로 쓰는 모듈만 루트 `pubspec.yaml`의 `melos.command.bootstrap.*`에 추가/수정
2. `dart run melos bootstrap` 실행
3. 각 패키지 `pubspec.yaml`의 버전이 동기화됨

## Melos 스크립트
- `dart run melos get`
- `dart run melos clean`
- `dart run melos analyze`
- `dart run melos test`
- `dart run melos format`
- `dart run melos format:check`

## 새 패키지 추가
1. `app` 또는 `packages/*`에 패키지 생성
2. 루트 `pubspec.yaml`의 `workspace:`에 경로 추가
3. 새 패키지 `pubspec.yaml`에 `resolution: workspace` 추가
4. `dart run melos bootstrap`
