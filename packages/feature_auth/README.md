# feature_auth

`feature_auth`는 **원격 인증(로그인/회원가입/로그아웃/계정삭제/프로필 갱신)** 도메인을 담당하는 기능 패키지입니다.
실제 원격 구현은 `infra_supabase`의 `SupabaseAuthDataSource`가 주입됩니다.

## 책임 범위
- 인증 도메인 엔티티 및 리포지토리 인터페이스 제공
- 인증 유스케이스 묶음(`AuthUseCase`) 제공
- 인증 상태 관리(`AuthBloc`, `SignInCubit`, `SignUpCubit`) 제공
- 에러/실패 타입(`AuthException`, `AuthFailure`) 제공

## Clean Architecture 구조
- `data`
  - `datasource/auth_datasource.dart`: 인증 데이터소스 추상화
  - `repository_impl/auth_repository_impl.dart`: `AuthRepository` 구현
  - `model/*`, `mapper/*`: 데이터 모델 <-> 도메인 엔티티 변환
- `domain`
  - `entity/*`: `AuthUser`, `Profile`
  - `repository/auth_repository.dart`: 도메인 계약
  - `usecase/*`: 시나리오별 유스케이스
- `presentation`
  - `bloc/auth/*`: 전역 인증 상태 스트림 반영
  - `cubit/sign_in/*`, `cubit/sign_up/*`: 폼 액션 처리

## 주요 파일과 역할
- `lib/src/presentation/bloc/auth/auth_bloc.dart`
  - 인증 스트림을 구독해 `authenticated` / `unauthenticated` 상태를 발행
- `lib/src/presentation/cubit/sign_in/sign_in_cubit.dart`
  - 이메일 로그인 제출/성공/실패 상태 관리
- `lib/src/presentation/cubit/sign_up/sign_up_cubit.dart`
  - 회원가입 제출/성공/실패 상태 관리
- `lib/src/domain/usecase/auth_use_case.dart`
  - 인증 유스케이스 집합(관찰, 로그인, 회원가입, 로그아웃, 계정삭제, 프로필갱신)
- `lib/src/data/datasource/auth_datasource.dart`
  - 원격 구현체가 따라야 하는 인터페이스

## Bloc/Cubit
- `AuthBloc`: 앱 전역 인증 세션 상태 동기화
- `SignInCubit`: 로그인 폼 1회 액션 상태 관리
- `SignUpCubit`: 회원가입 폼 1회 액션 상태 관리

## 테스트 코드
- `test/domain/usecase/scenario/*_test.dart`
  - 로그인/회원가입/로그아웃/계정삭제/프로필갱신/인증상태관찰 시나리오 테스트
- `test/domain/usecase/auth_use_case_test.dart`
  - `AuthUseCase` 조합 검증
- `test/helpers/mocks.dart`
  - `AuthDataSource`, `AuthRepository` mock
- `test/helpers/fixtures.dart`
  - `AuthUser`, `Profile` fixture builder

## feature_auth vs feature_security
- `feature_auth`: **원격 계정 인증**(Supabase 연동 대상)
- `feature_security`: **로컬 앱 잠금 비밀번호 인증**(기기 내부 저장)

## 개발 명령어
```bash
cd packages/feature_auth
flutter test
# 또는
flutter test test/domain/usecase
```

## 연관 패키지
- `core`
- `infra_supabase` (AuthDataSource 구현 제공)

## 상태
- 도메인/유스케이스/상태관리 레이어가 동작 중
- 실제 원격 인증 구현은 `infra_supabase`에서 제공
