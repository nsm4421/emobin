# EmoBin Workspace

EmoBin 모노레포 워크스페이스입니다.
Flutter 앱(`app`)과 기능/인프라 패키지(`packages/*`)를 하나의 저장소에서 관리합니다.

## 프로젝트 구성
- `app`: 실제 Flutter 애플리케이션
- `packages/core`: 공통 타입/유틸/위젯
- `packages/feature_feed`: 피드(일기) 도메인/상태관리
- `packages/feature_security`: 로컬 비밀번호 보안 기능
- `packages/feature_setting`: 설정(테마/언어/프리셋) 상태관리
- `packages/infra_drift`: Drift(SQLite) 기반 로컬 DB 구현
- `packages/infra_media_local`: 로컬 미디어 저장소 구현
- `packages/ui_theme`: 앱 전역 테마 시스템

## 개발 환경
- Flutter SDK: `3.9.x`
- Dart SDK: `3.9.x`
- melos: `7.x`

## 빠른 시작
```bash
# 워크스페이스 루트에서
flutter pub get
melos bootstrap

# 앱 실행
melos run run:app
# 또는
cd app
flutter run
```

## 자주 쓰는 명령어
```bash
# 전체 패키지 분석
melos run analyze

# 전체 테스트
melos run test

# 코드 생성(injectable, build_runner 등)
melos run codegen

# 앱 번들(AAB) 빌드
cd app
flutter build appbundle
```

빌드 결과물 예시:
- `app/build/app/outputs/bundle/release/app-release.aab`

## 개인정보 처리방침
- 영문 문서: `privacy-policy/README.md`
