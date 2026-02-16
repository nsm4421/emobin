# infra_supabase

`infra_supabase`는 Supabase 기반 인증/원격 데이터소스 구현을 제공하는 인프라 패키지입니다.

## 책임 범위
- Supabase 초기화 및 `SupabaseClient` DI 등록 제공
- `AuthDataSource`의 Supabase 구현체(`SupabaseAuthDataSource`) 제공
- 인증 에러를 도메인 예외로 매핑하는 로직 제공
- `FeedRemoteDataSource` Supabase 구현체 자리(`SupabaseFeedRemoteDataSource`) 제공

## 디렉터리
```text
lib/
  infra_supabase.dart
  src/
    core/
      env/
      di/
    auth/
    feed/
```

## 사용 예시
```dart
import 'package:infra_supabase/infra_supabase.dart';

Future<void> bootstrap() async {
  await initInfraSupabasePackage();
}
```

`.env.local` (패키지 루트 기준) 예시:
```dotenv
SUPABASE_PROJECT_URL=https://your-project.supabase.co
SUPABASE_PUBLISHABLE_KEY=your-publishable-key
```

## 개발 명령어
```bash
cd packages/infra_supabase
dart run build_runner build --delete-conflicting-outputs
flutter test
```

## 연관 패키지
- `feature_auth`
- `feature_feed`

## 상태
- 인증 데이터소스 구현은 동작합니다.
- `SupabaseFeedRemoteDataSource`의 `fetchEntries`, `upsertEntry`는 아직 `UnimplementedError` 상태입니다.
