# core

`core`는 워크스페이스 전반에서 재사용하는 공통 레이어 패키지입니다.

## 역할
- 공통 에러/실패 타입
- 공통 로깅 유틸
- 공통 extension
- 공통 UI 위젯
- 범용 상태 표현용 Bloc

## 공개 엔트리
- `lib/core.dart`

## 포함 모듈(요약)
- `src/errors/*`: 예외/실패 모델
- `src/extensions/*`: `BuildContext`, `String` 등 확장
- `src/widgets/*`: 재사용 UI 컴포넌트
- `src/logging/*`: 로깅 유틸
- `src/bloc/display/*`: 공통 표시 상태 Bloc

## 개발 명령어
```bash
cd packages/core
flutter analyze
```

## 의존 관계
- 사용처: `app`, `feature_*` 패키지
