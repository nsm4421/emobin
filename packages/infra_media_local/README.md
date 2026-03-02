# infra_media_local

`infra_media_local`은 로컬 파일 시스템 기반 미디어(이미지) 저장소 인프라 패키지입니다.
`feature_feed`의 이미지 저장소 계약을 구현합니다.

## 역할
- 이미지 로컬 저장/삭제 구현
- 파일 경로 생성/관리
- DI 모듈 제공

## 공개 엔트리
- `lib/infra_media_local.dart`

## 개발 명령어
```bash
cd packages/infra_media_local
flutter analyze
```

## 의존 관계
- 의존: `feature_feed`
- 사용처: `app`
