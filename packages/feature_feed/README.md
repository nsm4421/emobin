# feature_feed

`feature_feed`는 피드(일기) 도메인의 핵심 기능 패키지입니다.
생성/조회/수정/삭제, 목록 표시, 상세/수정/휴지통 상태 관리를 담당합니다.

## 역할
- 피드 도메인 엔티티/리포지토리 계약 정의
- 피드 유스케이스 집합(`FeedUseCase`) 제공
- 피드 관련 Bloc/Cubit 제공
- 피드 에러/실패 모델 제공

## 공개 엔트리
- `lib/feature_feed.dart`

## 아키텍처
- `data`: datasource 추상화, mapper, repository 구현
- `domain`: entity, repository 계약, usecase
- `presentation`: 목록/달력/생성/상세/수정/휴지통 상태관리

## 개발 명령어
```bash
cd packages/feature_feed
flutter test
flutter analyze
```

## 의존 관계
- 의존: `core`
- 구현체 제공 패키지: `infra_drift`, `infra_media_local`
