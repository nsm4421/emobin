# core

앱 전역에서 공통으로 사용하는 유틸, 로깅, 확장 메서드를 모아둔 패키지입니다.

## 구성

- utils: 타입 정의, 안전 캐스팅, 디바운서
- logging: 개발/프로덕션 모드 분리 로거
- extensions: String, Iterable, BuildContext 확장

## 사용 방법

```dart
import 'package:core/core.dart';

final json = <String, dynamic>{'ok': true};
final asMap = castOrNull<Map<String, dynamic>>(json);

AppLogger.log('hello', level: LogLevel.info);

final title = 'hello';
final cap = title.capitalize();
final cleaned = '   '.nullIfBlank;
```

## 로깅 모드

기본값은 릴리즈 빌드면 `prod`, 그 외는 `dev`입니다.
`dev`에서는 모든 로그가 보이고, `prod`에서는 `debug` 로그가 숨겨집니다.

```dart
AppLogger.setMode(LogMode.dev);
```

## 확장 메서드 예시

```dart
final items = [1, 2, 3, 4, 5];
final chunks = items.chunked(2);
final first = items.firstOrNull;
```

```dart
// BuildContext 확장
final primary = context.primaryColor;
final onPrimary = context.onPrimaryColor;
final padding = context.safeAreaPadding;
```
