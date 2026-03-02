# app

`app`은 EmoBin의 실제 Flutter 애플리케이션 패키지입니다.
워크스페이스의 기능/인프라 패키지를 조합해 화면, 라우팅, DI를 구성합니다.

## 역할
- 앱 엔트리포인트(`lib/main.dart`) 제공
- 화면 라우팅(`auto_route`) 구성
- 의존성 주입(GetIt + injectable) 초기화
- 로컬라이제이션(`l10n`) 및 테마 연결

## 주요 디렉터리
- `lib/core`: 앱 공통 설정, DI, 확장, 토스트
- `lib/features`: 앱 화면 레벨 UI/흐름
- `lib/router`: 라우트 정의 및 생성 파일
- `lib/l10n`: 다국어 리소스(ARB) 및 생성 코드

## 실행
```bash
cd app
flutter pub get
flutter run
```

## 빌드
```bash
cd app
flutter build apk
flutter build appbundle
```

## 코드 생성
```bash
# 라우터, DI 등 생성 코드 갱신
cd /Users/n/Desktop/emobin
melos run codegen

# 또는 app 단독
cd app
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

## 비고
- 워크스페이스 루트에서 `flutter build ...`를 실행하면 타깃 파일(`lib/main.dart`)을 못 찾을 수 있습니다.
- 앱 빌드는 `app` 디렉터리에서 실행하세요.
