# ui_theme

`ui_theme`는 앱 전역 테마(팔레트/컬러스킴/텍스트/ThemeData)를 제공하는 디자인 토큰 패키지입니다.

## 책임 범위
- `AppPalette`: 색상 토큰 정의
- `AppColorSchemes`: 라이트/다크 컬러스킴
- `AppTextThemes`: 텍스트 스타일 시스템
- `AppTheme.light`, `AppTheme.dark`: 최종 ThemeData

## 아키텍처 위치
- 기능 패키지의 `data/domain/presentation` 구조가 아니라,
  UI 시스템 전반에서 공유하는 디자인 레이어입니다.

## 주요 파일과 역할
- `lib/src/palette.dart`: 기본 색상 토큰
- `lib/src/color_scheme.dart`: Material `ColorScheme` 조합
- `lib/src/text_theme.dart`: 타입 스케일
- `lib/src/theme_data.dart`: 앱 테마 최종 조립
- `lib/ui_theme.dart`: 외부 공개 entrypoint

## Bloc/Cubit
- 없음

## 테스트 코드
- 현재 `test/` 없음
- 권장 추가 범위:
  - 주요 토큰/컬러스킴 스냅샷 테스트
  - 테마 대비(명도/텍스트 가독성) 검증 테스트

## 개발 명령어
```bash
cd packages/ui_theme
flutter analyze
```

## 연관 패키지
- `app`

## 상태
- 전역 테마 패키지로 사용 중
- 디자인 변경 시 단일 지점에서 토큰 관리 가능
