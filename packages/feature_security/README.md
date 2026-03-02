# feature_security

`feature_security`는 앱 잠금 비밀번호의 저장/검증/삭제를 담당하는 보안 기능 패키지입니다.
원격 인증이 아니라, 디바이스 로컬 보안 흐름에 집중합니다.

## 역할
- 보안 도메인 계약/유스케이스 제공
- `SecurityBloc` 기반 잠금 상태 관리
- 로컬 보안 저장소 datasource 계약 제공

## 공개 엔트리
- `lib/feature_security.dart`

## 개발 명령어
```bash
cd packages/feature_security
flutter test
flutter analyze
```

## 의존 관계
- 의존: `core`
- 사용처: `app`
