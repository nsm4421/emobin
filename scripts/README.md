# Scripts

## `seed_fake_feed.dart`
`feed_entries` 테이블에 가짜 피드 데이터를 넣는 시드 스크립트입니다.
현재 스키마 기준으로 `is_draft`는 항상 `false`로 저장됩니다.

### 실행
프로젝트 루트에서 실행:

```bash
dart run scripts/seed_fake_feed.dart --db-path /path/to/emobin.sqlite --count 50 --clear
```

Android 에뮬레이터/디바이스에서 앱이 실제로 사용하는 DB(`app_flutter/emobin.sqlite`)에 직접 넣기:

```bash
dart run scripts/seed_fake_feed.dart --android-package com.karma.emobin --count 50 --clear
```

### 자주 쓰는 예시
```bash
# 테스트 DB에 30개 생성
dart run scripts/seed_fake_feed.dart --db-path /tmp/emobin.sqlite --count 30 --clear

# 기존 데이터 유지하고 20개 추가
dart run scripts/seed_fake_feed.dart --db-path /tmp/emobin.sqlite --count 20

# 고정 시드로 재현 가능한 데이터 생성
dart run scripts/seed_fake_feed.dart --db-path /tmp/emobin.sqlite --count 50 --clear --seed 42
```

### 옵션
- `--db-path`: SQLite 파일 경로 (기본값: `emobin.sqlite`)
- `--android-package`: Android 앱 패키지명. 지정 시 `adb run-as`로 앱 DB 직접 업데이트
- `--adb-path`: adb 실행 경로 (기본값: 자동 탐지)
- `--count`: 생성 개수 (기본값: `30`)
- `--created-by`: `created_by` 값 (기본값: `seed_bot`)
- `--days`: 최근 N일 범위로 `created_at` 생성 (기본값: `14`)
- `--seed`: 랜덤 시드 고정값
- `--clear`: 기존 데이터 삭제 후 삽입
- `--help`: 도움말 출력
