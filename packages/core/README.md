# core

`core`는 앱 전역에서 공통으로 사용하는 유틸리티, 에러 타입, 로깅, 확장 메서드, 공용 위젯을 제공하는 패키지입니다.

## 책임 범위
- 안전 캐스팅, 디바운서, 공통 typedef 제공
- 앱 공통 로깅(`AppLogger`) 제공
- `String`, `Iterable`, `BuildContext` 확장 제공
- 공통 에러/실패 타입 제공
- 공통 UI 위젯 및 display bloc 제공

## 디렉터리
```text
lib/
  core.dart
  src/
    utils/
    logging/
    extensions/
    errors/
    bloc/display/
    widgets/
    value_objects/
test/
```

## 사용 예시
```dart
import 'package:core/core.dart';

final asMap = castOrNull<Map<String, dynamic>>({'ok': true});
AppLogger.log('hello', level: LogLevel.info);

final title = 'hello'.capitalize();
final chunks = [1, 2, 3, 4].chunked(2);

final maybeBlank = '   '.nullIfBlank;
```

## 개발 명령어
```bash
cd packages/core
flutter test
```

## 연관 패키지
- `app`
- `feature_auth`
- `feature_feed`

## 상태
- 운영 중이며 공통 타입/도구를 지속 확장하는 기반 패키지입니다.
