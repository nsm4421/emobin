# feature_feed

`feature_feed`는 피드 엔트리의 조회/생성/수정/삭제와 동기화 유스케이스를 제공하는 패키지입니다.

## 책임 범위
- 피드 도메인 엔티티/리포지토리 인터페이스 제공
- 로컬 피드 유스케이스(`FeedUseCase`) 제공
- 동기화 상태(`FeedSyncStatus`) 및 에러 타입 제공
- DI 마이크로 패키지 초기화(`initFeatureFeedPackage`) 제공

## 디렉터리
```text
lib/
  feature_feed.dart
  core/
    constants/
    errors/
    types/
    di/
  data/
    datasource/
    mapper/
    model/
    repository_impl/
  domain/
    entity/
    repository/
    usecase/
test/
  domain/usecase/
```

## 사용 예시
```dart
import 'package:feature_feed/feature_feed.dart';
import 'package:get_it/get_it.dart';

final feedUseCase = GetIt.I<FeedUseCase>();

final entriesResult = await feedUseCase.fetchLocalEntries();

await feedUseCase.createLocalEntry(
  FeedEntryDraft(eventText: '오늘 있었던 일', emotion: '불안'),
);

await feedUseCase.syncPendingLocalEntriesToRemote();
```

## 개발 명령어
```bash
cd packages/feature_feed
flutter test test/domain/usecase
dart run build_runner build --delete-conflicting-outputs
```

## 연관 패키지
- `core`
- `infra_drift` (FeedLocalDataSource 구현 제공)
- `infra_supabase` (FeedRemoteDataSource 구현 제공)

## 상태
- 도메인/유스케이스 레이어는 테스트와 함께 운영 중입니다.
- 원격 동기화 동작은 주입되는 인프라 구현 수준에 따라 완성도가 달라집니다.
