# feature_auth

`feature_auth`는 인증/회원 관련 도메인 로직과 상태 관리를 담당하는 패키지입니다.

## 책임 범위
- `AuthRepository` 인터페이스와 인증 유스케이스 묶음(`AuthUseCase`) 제공
- 인증 도메인 엔티티(`AuthUser`, `Profile`) 제공
- 인증 상태 관리(`AuthBloc`, `SignInCubit`, `SignUpCubit`) 제공
- DI 마이크로 패키지 초기화(`initFeatureAuthPackage`) 제공

## 디렉터리
```text
lib/
  feature_auth.dart
  core/
    constants/
    errors/
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
  presentation/
    bloc/
    cubit/
test/
  domain/usecase/
```

## 사용 예시
```dart
import 'package:feature_auth/feature_auth.dart';
import 'package:get_it/get_it.dart';

final authUseCase = GetIt.I<AuthUseCase>();

final signIn = await authUseCase.signInWithEmail(
  email: 'user@example.com',
  password: 'pw123456',
);

await authUseCase.signOut();

authUseCase.observeAuthState().listen((payload) {
  // payload.status, payload.user
});
```

## 개발 명령어
```bash
cd packages/feature_auth
flutter test test/domain/usecase
dart run build_runner build --delete-conflicting-outputs
```

## 연관 패키지
- `core`
- `infra_supabase` (AuthDataSource 구현 제공)

## 상태
- 도메인/유스케이스/상태관리 흐름은 사용 중입니다.
- 데이터소스 구현체는 외부 인프라 패키지에서 주입받는 구조입니다.
