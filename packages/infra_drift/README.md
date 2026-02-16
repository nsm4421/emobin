# infra_drift

`infra_drift`는 Drift(SQLite) 기반 로컬 인프라 구현 패키지입니다.
`feature_feed`의 `FeedLocalDataSource` 계약을 실제 DB 구현으로 제공합니다.

## 책임 범위
- Drift DB(`EmobinDatabase`) 및 스키마 제공
- 로컬 피드 datasource 구현(`DriftFeedLocalDataSource`) 제공
- feed row/model 매핑 제공
- 마이크로 DI 모듈 제공

## 아키텍처 위치
- Clean Architecture 기준으로 **Infrastructure(Data 구현체)** 레이어
- `feature_feed`의 `data/datasource` 인터페이스를 구현

## 주요 파일과 역할
- `lib/src/core/database/drift_database.dart`
  - DB 연결/버전/마이그레이션 전략
- `lib/src/core/schema/feed_entry.dart`
  - `feed_entries` 테이블 정의
- `lib/src/feed/drift_feed_local_datasource.dart`
  - 목록 조회/스트림/추가/수정/삭제/upsert
- `lib/src/feed/drift_feed_entry_mapper.dart`
  - Drift row <-> `FeedEntryModel` 변환

## Bloc/Cubit
- 없음 (인프라 패키지)

## 테스트 코드
- `test/drift_feed_local_datasource_test.dart`
  - in-memory Drift DB 기반 datasource 통합 성격 테스트
  - 정렬/갱신/삭제 예외/필터/watch/upsert 시나리오 검증

## 개발 명령어
```bash
cd packages/infra_drift
flutter test
```

## 연관 패키지
- `feature_feed`

## 상태
- 피드 로컬 저장소 구현으로 사용 중
- 스키마 변경 시 마이그레이션/코드생성 점검 필요
