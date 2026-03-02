# infra_drift

`infra_drift`는 Drift(SQLite) 기반 로컬 DB 인프라 패키지입니다.
`feature_feed`의 로컬 데이터소스 계약을 실제 DB로 구현합니다.

## 역할
- Drift DB 연결/스키마/마이그레이션 관리
- `feed_entries` 테이블 접근 구현
- row <-> model 매핑
- DI 모듈 제공

## 공개 엔트리
- `lib/infra_drift.dart`

## 개발 명령어
```bash
cd packages/infra_drift
flutter test
flutter analyze
```

## 의존 관계
- 의존: `feature_feed`
- 사용처: `app`
