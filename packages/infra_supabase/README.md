# infra_supabase

`infra_supabase`는 Supabase 기반 원격 인프라 구현 패키지입니다.
`feature_auth`(원격 인증)와 `feature_feed`(원격 피드 datasource)의 구현체를 제공합니다.

## 책임 범위
- Supabase 초기화/DI 등록
- `AuthDataSource`의 Supabase 구현 제공
- Supabase 예외를 도메인 예외로 매핑
- `FeedRemoteDataSource` 구현 스켈레톤 제공

## 아키텍처 위치
- Clean Architecture 기준으로 **Infrastructure(Data 구현체)** 레이어
- `feature_auth`, `feature_feed`의 datasource 인터페이스 구현

## 주요 파일과 역할
- `lib/src/core/di/supabase_module.dart`
  - `SupabaseClient` 주입 구성
- `lib/src/core/di/di.dart`
  - 패키지 초기화
- `lib/src/auth/supabase_auth_datasource.dart`
  - 이메일 가입/로그인/로그아웃/계정삭제/프로필갱신
- `lib/src/auth/supabase_auth_exception_mapper.dart`
  - Supabase 에러 -> `AuthException` 변환
- `lib/src/feed/supabase_feed_remote_datasource.dart`
  - 피드 원격 datasource (현재 미구현)

## Bloc/Cubit
- 없음 (인프라 패키지)

## 테스트 코드
- 현재 `test/` 없음
- 권장 추가 범위:
  - auth datasource 예외 매핑 테스트
  - feed remote datasource 구현 시 API contract 테스트

## feature_auth vs feature_security 관점
- `infra_supabase`는 `feature_auth`의 **원격 인증 구현체**를 제공
- `feature_security`(로컬 비밀번호)는 Supabase와 무관

## 개발 명령어
```bash
cd packages/infra_supabase
dart run build_runner build --delete-conflicting-outputs
```

## 연관 패키지
- `feature_auth`
- `feature_feed`

## 상태
- 인증 datasource는 동작 중
- feed remote datasource는 아직 `UnimplementedError` 상태
