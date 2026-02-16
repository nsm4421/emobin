# feature_security

`feature_security`는 기기 로컬에 민감 값을 안전 저장하기 위한 최소 보안 저장소를 제공합니다.

## 책임 범위
- `FlutterSecureStorage` 기반 비밀번호 저장/조회/삭제 제공
- 저장 여부 확인(`hasPassword`) 제공
- 기본 저장 키(`local_password`) 상수 제공

## 디렉터리
```text
lib/
  feature_security.dart
  src/
    local_password_storage.dart
test/
  feature_security_test.dart
```

## 사용 예시
```dart
import 'package:feature_security/feature_security.dart';

final storage = LocalPasswordStorage();

await storage.savePassword('1234');
final saved = await storage.readPassword();
final exists = await storage.hasPassword();

if (!exists || saved == null) {
  // 비밀번호 미설정 상태 처리
}
```

## 개발 명령어
```bash
cd packages/feature_security
flutter test
```

## 연관 패키지
- 현재 workspace 내부 직접 의존 패키지 없음

## 상태
- 단일 책임(로컬 비밀번호 저장소)에 집중된 경량 패키지입니다.
