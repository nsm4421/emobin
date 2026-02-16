# feature_security

`feature_security`는 **로컬 앱 잠금 비밀번호** 저장/검증/삭제를 담당하는 기능 패키지입니다.
원격 계정 인증(`feature_auth`)과 분리된, 디바이스 내부 보안 레이어입니다.

## 책임 범위
- 로컬 비밀번호 저장/검증/삭제/존재확인 유스케이스 제공
- `SecurityBloc` 기반 잠금 상태(`locked` / `unlocked`) 관리
- `SecurityDataSource` 추상화와 실패 타입 제공

## Clean Architecture 구조
- `data`
  - `datasource/security_datasource.dart`: 로컬 보안 저장소 인터페이스
  - `datasource/secure_storage_security_datasource.dart`: `flutter_secure_storage` 구현
  - `repository_impl/security_repository_impl.dart`
- `domain`
  - `repository/security_repository.dart`
  - `usecase/security_use_case.dart` + scenario usecase들
- `presentation`
  - `bloc/security/security_bloc.dart`: 보안 상태 전환 이벤트 처리

## 주요 파일과 역할
- `lib/src/presentation/bloc/security/security_bloc.dart`
  - 시작 시 비밀번호 존재 확인
  - 저장/검증/삭제 이벤트 처리
- `lib/src/domain/usecase/security_use_case.dart`
  - save/verify/delete/has usecase 집합
- `lib/src/data/datasource/secure_storage_security_datasource.dart`
  - 실제 기기 보안 저장소 접근

## Bloc/Cubit
- `SecurityBloc`
  - `started`, `savePasswordRequested`, `verifyPasswordRequested`, `deletePasswordRequested` 이벤트 처리
  - `loading`, `locked`, `unlocked` 상태 발행

## 테스트 코드
- `test/feature_security_test.dart`
  - `SecureStorageSecurityDataSource` 테스트
  - 저장/검증/예외(empty password) 시나리오 검증

## feature_auth vs feature_security
- `feature_auth`: Supabase 기반 **원격 계정 인증**
- `feature_security`: Secure Storage 기반 **로컬 앱 잠금 인증**

## 개발 명령어
```bash
cd packages/feature_security
flutter test
```

## 연관 패키지
- `core`
- `app`

## 상태
- 로컬 비밀번호 플로우 동작 중
- 네트워크와 무관한 로컬 보안 기능 패키지
