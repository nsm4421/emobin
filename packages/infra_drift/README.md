# infra_drift

`infra_drift`는 Drift(SQLite) 기반 로컬 저장소 구현을 제공하는 인프라 패키지입니다.

## 책임 범위
- `EmobinDatabase` 및 `FeedEntries` 스키마 제공
- `FeedLocalDataSource`의 Drift 구현체(`DriftFeedLocalDataSource`) 제공
- 피드 로컬 데이터 조회/추가/수정/삭제/스트림/watch 제공
- DI 마이크로 패키지 초기화(`initInfraDriftPackage`) 제공

## 디렉터리
```text
lib/
  infra_drift.dart
  src/
    core/
      database/
      schema/
      di/
    feed/
test/
  drift_feed_local_datasource_test.dart
```

## 사용 예시
```dart
import 'package:feature_feed/src/data/datasource/feed_local_datasource.dart';
import 'package:get_it/get_it.dart';
import 'package:infra_drift/infra_drift.dart';

await initInfraDriftPackage();

final localDataSource = GetIt.I<FeedLocalDataSource>();
final entries = await localDataSource.fetchEntries();
```

## 개발 명령어
```bash
cd packages/infra_drift
flutter test
dart run build_runner build --delete-conflicting-outputs
```

## 연관 패키지
- `feature_feed`

## 상태
- `feature_feed` 로컬 저장소 구현으로 사용 중입니다.
- 스키마 변경 시 build_runner 재생성이 필요합니다.
