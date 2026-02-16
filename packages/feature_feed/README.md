# feature_feed

`feature_feed`는 피드 엔트리의 생성/조회/수정/삭제와 동기화 상태 관리를 담당하는 기능 패키지입니다.
로컬 데이터소스는 `infra_drift`, 원격 데이터소스는 `infra_supabase` 구현체를 주입받습니다.

## 책임 범위
- 피드 도메인 엔티티/리포지토리 계약 제공
- 로컬/원격 데이터소스 추상화 제공
- 피드 유스케이스(`FeedUseCase`) 제공
- 목록/생성 상태관리(`DisplayFeedListBloc`, `CreateFeedCubit`) 제공
- 동기화 상태/에러 모델 제공

## Clean Architecture 구조
- `data`
  - `datasource/feed_local_datasource.dart`, `feed_remote_datasource.dart`
  - `repository_impl/feed_repository_impl.dart`
  - `model/*`, `mapper/*`
- `domain`
  - `entity/*`: `FeedEntry`, `FeedEntryDraft`, `FeedProfile`
  - `repository/feed_repository.dart`
  - `usecase/*`: 조회/추가/수정/삭제/동기화 시나리오
- `presentation`
  - `bloc/display_feed_list/*`: 목록 로딩/갱신/오류 상태
  - `cubit/create_feed/*`: 작성 제출 상태

## 주요 파일과 역할
- `lib/src/presentation/bloc/display_feed_list/display_feed_list_bloc.dart`
  - 목록 최초 로드, pull-to-refresh, 로컬 스트림 구독 처리
- `lib/src/presentation/cubit/create_feed/create_feed_cubit.dart`
  - 피드 작성 제출 상태 관리
- `lib/src/domain/usecase/feed_use_case.dart`
  - 피드 유스케이스 집합
- `lib/src/data/repository_impl/feed_repository_impl.dart`
  - datasource 조합 + 실패 매핑
- `lib/src/core/constants/feed_sync_status.dart`
  - `localOnly`, `pendingUpload`, `synced`, `conflict`

## Bloc/Cubit
- `DisplayFeedListBloc`: 피드 목록 표시 상태 관리
- `CreateFeedCubit`: 피드 작성 액션 상태 관리

## 테스트 코드
- `test/domain/usecase/scenario/*_test.dart`
  - 각 시나리오 유스케이스 단위 테스트
- `test/domain/usecase/feed_use_case_test.dart`
  - `FeedUseCase` 조합 검증
- `test/presentation/bloc/display_feed_list/display_feed_list_bloc_test.dart`
  - 목록 상태 전이 테스트
- `test/presentation/cubit/create_feed/create_feed_cubit_test.dart`
  - 작성 상태 전이 테스트
- `test/helpers/mocks.dart`, `test/helpers/fixtures.dart`
  - repository mock, 엔티티 fixture

## 개발 명령어
```bash
cd packages/feature_feed
flutter test
```

## 연관 패키지
- `core`
- `infra_drift` (FeedLocalDataSource 구현)
- `infra_supabase` (FeedRemoteDataSource 구현)

## 상태
- 로컬 중심 피드 플로우는 동작 중
- 원격 피드 구현은 `infra_supabase` 구현 상태에 의존
