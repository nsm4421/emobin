# core

`core`는 앱/기능 패키지 전반에서 공통으로 사용하는 타입, 로깅, 확장, UI 컴포넌트를 제공하는 기반 패키지입니다.

## 책임 범위
- 공통 에러/실패 타입
- 공통 로깅(`AppLogger`)
- 공통 확장 메서드(`BuildContext`, `String`, `Iterable`)
- 공통 위젯(`AppPrimaryButton`, `AppPasswordField` 등)
- 공통 상태표현용 `DisplayBloc`

## 아키텍처 위치
- 특정 기능의 `data/domain/presentation`을 가지는 패키지가 아니라,
  여러 마이크로 패키지가 공유하는 공통 레이어입니다.

## 주요 파일과 역할
- `lib/src/errors/*`: `AppException`, `Failure`
- `lib/src/logging/logging.dart`: 로그 레벨/출력
- `lib/src/extensions/build_context_extensions.dart`: theme/color/text 접근 단축
- `lib/src/widgets/*`: 재사용 UI 위젯 세트
- `lib/src/bloc/display/display_bloc.dart`: 로딩/데이터/에러 표현용 범용 bloc

## Bloc/Cubit
- `DisplayBloc`
  - 공용 화면 상태(`loading/success/failure`) 표현에 사용

## 테스트 코드
- 현재 `test/` 없음
- 권장 추가 범위:
  - extension 유틸 함수 테스트
  - display bloc 상태 전이 테스트

## 개발 명령어
```bash
cd packages/core
flutter analyze
```

## 연관 패키지
- `app`
- `feature_auth`
- `feature_feed`
- `feature_security`

## 상태
- 공통 기반 패키지로 운영 중
- 기능 패키지 증가에 따라 공용 타입/컴포넌트 확장 예정
