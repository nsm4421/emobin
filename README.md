# emobin

`emobin`은 Flutter 모노레포이며, `app`과 여러 기능/인프라 패키지를 Melos 워크스페이스로 관리합니다.

## 워크스페이스 구성
- `app`: 실제 Flutter 앱
- `packages/core`: 공통 유틸/에러/위젯
- `packages/feature_auth`: 인증 도메인
- `packages/feature_feed`: 피드 도메인
- `packages/feature_security`: 로컬 보안 저장소
- `packages/infra_drift`: Drift 기반 로컬 인프라
- `packages/infra_supabase`: Supabase 기반 원격 인프라
- `packages/ui_theme`: 전역 테마

## 빠른 시작
```bash
dart run melos get
dart run melos bootstrap
cd app && flutter run
```

## 주요 명령어
- 의존성 설치: `dart run melos get`
- 워크스페이스 부트스트랩: `dart run melos bootstrap`
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

## feed_entries 스키마 (v9)
- `id` (TEXT, PK)
- `server_id` (TEXT, NULL)
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
