# ui_theme

`ui_theme`는 앱 전역에서 공통으로 사용하는 색상 팔레트와 `ThemeData`를 제공하는 패키지입니다.

## 구성

- 팔레트: `AppPalette` (차가운 블루-그레이 톤 기반)
- 컬러 스킴: `AppColorSchemes` (light / dark)
- 텍스트 테마: `AppTextThemes` (한국어에 맞춘 폰트 설정 포함)
- 테마 데이터: `AppTheme` (Material 3 기준)

## 사용 방법

```dart
import 'package:ui_theme/ui_theme.dart';

MaterialApp(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: ThemeMode.system,
);
```

## 폰트 설정

텍스트 테마는 기본적으로 `Noto Sans KR`을 사용하며, 시스템 폰트로 다음 폴백을 지정해두었습니다.

- `Apple SD Gothic Neo`
- `Noto Sans CJK KR`
- `Malgun Gothic`

앱에서 폰트 파일을 직접 포함해 사용하고 싶다면,
`pubspec.yaml`의 `fonts` 섹션에 등록한 뒤 `AppTextThemes`의 `fontFamily`를 변경하세요.

## 커스텀 컬러 조정

브랜드 톤을 바꾸고 싶다면 `AppPalette`의 `primary/secondary/tertiary` 및
관련 `onPrimary`, `container` 계열 값을 수정하면 됩니다.

