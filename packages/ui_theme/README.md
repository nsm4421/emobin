# ui_theme

`ui_theme`는 앱 전역에서 사용하는 색상/타이포그래피/ThemeData를 제공하는 패키지입니다.

## 책임 범위
- 공통 팔레트(`AppPalette`) 제공
- 라이트/다크 컬러 스킴(`AppColorSchemes`) 제공
- 공통 텍스트 테마(`AppTextThemes`) 제공
- Material 3 기반 테마(`AppTheme.light`, `AppTheme.dark`) 제공

## 디렉터리
```text
lib/
  ui_theme.dart
  src/
    palette.dart
    color_scheme.dart
    text_theme.dart
    theme_data.dart
```

## 사용 예시
```dart
import 'package:flutter/material.dart';
import 'package:ui_theme/ui_theme.dart';

MaterialApp(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: ThemeMode.system,
);
```

## 개발 명령어
```bash
cd packages/ui_theme
flutter test
```

## 연관 패키지
- `app`

## 상태
- 디자인 토큰과 앱 기본 테마를 제공하는 안정 단계 패키지입니다.
