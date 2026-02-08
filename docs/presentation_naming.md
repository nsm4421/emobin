# Presentation 네이밍 규칙

작성일: 2026-02-08

**용어 정의**
- Screen: 라우트 최상위 화면( `@RoutePage()` 대상 )
- Page: 라우팅/DI 래퍼가 필요할 때만 사용(예: `BlocProvider`, `AutoRouteWrapper`)
- Section: 화면 내 큰 UI 덩어리(폼/리스트/헤더 등)
- Widget: 재사용 소형 컴포넌트

**파일/클래스 네이밍**
- 파일명: `snake_case` + 타입 suffix
- 클래스명: `PascalCase` + 타입 suffix
- 원칙: 파일당 public 클래스 1개(파일명과 동일)
- 내부 전용 위젯은 `_PrivateWidget`로 파일 내에 유지

**폴더 구조**
- `presentation/screens/` : `*_screen.dart`
- `presentation/pages/` : `*_page.dart` (필요할 때만)
- `presentation/sections/` : `*_section.dart`
- `presentation/widgets/` : `*_button.dart`, `*_card.dart`, `*_tile.dart`, `*_field.dart`

**예시**
- `login_screen.dart` / `LoginScreen`
- `login_page.dart` / `LoginPage`
- `login_form_section.dart` / `LoginFormSection`
- `primary_button.dart` / `PrimaryButton`

**적용 원칙**
- `Screen`은 라우트 화면만 담당, 순수 UI 중심
- `Page`는 의존성 주입/라우팅 래퍼 전용
- `Widget`은 가능한 의미적 suffix 사용(`Button/Tile/Card/Field`)
