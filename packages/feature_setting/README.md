# feature_setting

`feature_setting`은 앱 설정 관련 상태와 로컬 저장을 담당하는 기능 패키지입니다.
테마, 로케일, 해시태그/감정 프리셋을 관리합니다.

## 역할
- `AppThemeModeCubit`: 테마 모드 관리
- `AppLocaleCubit`: 언어 설정 관리
- `FeedEmotionPresetCubit`: 감정 프리셋 관리
- `FeedHashtagPresetCubit`: 해시태그 프리셋 관리
- 설정 관련 DI 등록

## 공개 엔트리
- `lib/feature_setting.dart`

## 개발 명령어
```bash
cd packages/feature_setting
flutter analyze
```

## 의존 관계
- 의존: `ui_theme`, `shared_preferences`
- 사용처: `app`
