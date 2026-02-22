# emobin

`emobin`은 Flutter 모노레포이며, `app`과 여러 기능/인프라 패키지를 Melos 워크스페이스로 관리합니다.

## 워크스페이스 구성
- `app`: 실제 Flutter 앱
- `packages/core`: 공통 유틸/에러/위젯
- `packages/feature_auth`: 인증 도메인
- `packages/feature_feed`: 피드 도메인
- `packages/feature_security`: 로컬 보안 저장소
- `packages/feature_setting`: 앱 설정 도메인
- `packages/infra_drift`: Drift 기반 로컬 인프라
- `packages/infra_media_local`: 로컬 미디어 저장/처리 인프라
- `packages/infra_supabase`: Supabase 기반 원격 인프라
- `packages/ui_theme`: 전역 테마

## 빠른 시작
```bash
dart run melos get
dart run melos bootstrap
cd app && flutter run
```

## 오프라인 실행
처음 1회 온라인 환경에서 아래 명령으로 의존성을 캐시에 준비합니다.
```bash
dart run melos get
dart run melos bootstrap
```

오프라인에서는 `pub get`를 다시 시도하지 않도록 아래 명령을 사용합니다.
```bash
dart run melos run run:app:offline
```

`pubspec.yaml`이 바뀌었고 잠금 파일 기준으로 재해석이 필요하면 다음 명령을 사용합니다.
```bash
dart run melos run get:offline
```

## 최근 업데이트 (2026-02-22 기준)
- `infra_supabase`의 피드 원격 데이터소스가 `restoreEntries`/`backupEntries`를 구현했습니다.
- 원격 백업은 로그인 사용자(`user_id`) 기준으로 동작하며, `id` 충돌 시 upsert로 병합합니다.
- 피드 이미지 저장/삭제(`SaveFeedImageUseCase`, `DeleteFeedImageUseCase`)와 기록 상태 조회/구독 유스케이스가 테스트로 보강되었습니다.
- `scripts/seed_fake_feed.dart`가 `emotion`, `emotion_id`, `intensity`, `created_by` 컬럼 데이터를 포함해 시드하도록 확장되었습니다.

## 주요 명령어
- 의존성 설치: `dart run melos get`
- 의존성 설치(오프라인 캐시만 사용): `dart run melos run get:offline`
- 워크스페이스 부트스트랩: `dart run melos bootstrap`
- 앱 실행(온라인/기본): `dart run melos run run:app`
- 앱 실행(오프라인, pub get 생략): `dart run melos run run:app:offline`
- 정적 분석: `dart run melos analyze`
- 테스트: `dart run melos test`
- 포맷 적용: `dart run melos format`
- 포맷 검사: `dart run melos format:check`

## 코드 생성
```bash
dart run melos codegen
```

## 피드 더미 데이터 시드
```bash
dart run scripts/seed_fake_feed.dart --db-path /path/to/emobin.sqlite --count 50 --clear
```

- 주요 옵션
  - `--days <n>`: 최근 `n`일 범위의 `created_at` 생성 (기본값: 14)
  - `--seed <n>`: 재현 가능한 랜덤 시드 고정
  - `--android-package <package>`: adb `run-as`로 기기 앱 DB에 직접 반영
  - `--adb-path <path>`: adb 실행 파일 경로 명시 (미지정 시 PATH/SDK 경로 자동 탐색)
- 참고: 스크립트는 시드 대상 DB에 누락된 보조 컬럼(`emotion`, `emotion_id`, `intensity`, `created_by`)이 있으면 자동으로 추가합니다.

## feed_entries 스키마 (v10, 로컬 Drift 기준)
- `id` (TEXT, PK)
- `server_id` (TEXT, NULL)
- `title` (TEXT, NULL)
- `note` (TEXT, NULL)
- `hashtags` (TEXT, NULL, JSON 배열 문자열)
- `image_local_path` (TEXT, NULL)
- `image_remote_path` (TEXT, NULL)
- `image_remote_url` (TEXT, NULL)
- `created_at` (INTEGER, NOT NULL)
- `updated_at` (INTEGER, NULL)
- `deleted_at` (INTEGER, NULL)
- `is_draft` (INTEGER/BOOL, NOT NULL, default 0)
- `sync_status` (TEXT, NOT NULL)
- `last_synced_at` (INTEGER, NULL)

## 새 패키지 추가
1. `packages/<name>` 또는 `app` 하위에 패키지를 생성합니다.
2. 루트 `pubspec.yaml`의 `workspace:`에 경로를 추가합니다.
3. 새 패키지 `pubspec.yaml`에 `resolution: workspace`를 설정합니다.
4. `dart run melos bootstrap`을 실행합니다.

## 문서 규칙
README 표준화 규칙은 `docs/plan.md`의 `README 표준화 규칙 (v1.0)` 섹션을 따릅니다.
