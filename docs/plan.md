# README 표준화 규칙 (v1.0)

작성일: 2026-02-16

## 목적
- 모노레포의 README 문서를 동일한 구조로 맞춰 탐색 비용을 낮춘다.
- 패키지별 책임 범위와 실행 명령어를 빠르게 찾을 수 있게 한다.
- 신규 패키지 추가 시 문서 품질을 일관되게 유지한다.

## 적용 범위
- 루트 `README.md`
- `packages/*/README.md` 전체

## 공통 작성 원칙
- 문서 언어는 한국어를 기본으로 한다.
- 첫 문단은 "이 패키지가 무엇을 하는가"를 1~2문장으로 요약한다.
- 구현 상세를 장문으로 나열하지 않고, 공개 API와 사용 흐름 중심으로 작성한다.
- 명령어는 모두 실행 가능한 형태로 제공한다.
- 미구현 기능은 숨기지 말고 `상태` 섹션에서 명시한다.

## 루트 README 섹션 순서
1. `# emobin` (워크스페이스 개요)
2. `## 워크스페이스 구성`
3. `## 빠른 시작`
4. `## 주요 명령어`
5. `## 코드 생성`
6. `## 새 패키지 추가`
7. `## 문서 규칙`

## 패키지 README 섹션 순서
1. `# <package_name>` (패키지 개요)
2. `## 책임 범위`
3. `## 디렉터리`
4. `## 사용 예시`
5. `## 개발 명령어`
6. `## 연관 패키지`
7. `## 상태`

## 작성 세부 규칙
- `디렉터리`는 `lib/`, `test/` 기준으로 2~3 단계까지만 표기한다.
- `사용 예시`는 실제 export/API를 기준으로 10~25줄 내에서 작성한다.
- `개발 명령어`는 최소 `flutter test`를 포함하고, 코드 생성이 필요한 패키지는 `build_runner` 명령을 함께 적는다.
- `연관 패키지`는 workspace 내부 의존성만 기재한다.
- `상태`에는 안정/개선중/미구현 정보를 한 줄 이상 반드시 작성한다.

## app 패키지 UI 폴더 구조/네이밍 규칙 (v1.4)
- 대상: `app/lib/features/**`
- 기존 `app/lib/pages/**` 구조는 사용하지 않고, 신규 UI 코드는 모두 `features` 하위에 배치한다.
- 현재 최상위 feature 폴더 표준: `auth`, `entry`, `feed`, `splash`
- 역할별 폴더(`view`, `sections`, `widgets`) 분리는 신규 코드에서 사용하지 않는다.
- 신규 UI 파일은 기능 폴더 내부에서 `prefix`로 분류한다.
- `pg_*.dart`: 라우트 진입 파일
- `sc_*.dart`: 화면 조합 파일
- `fg_*.dart`: 화면 블록 파일 (기존 Section 대체)
- `wd_*.dart`: 재사용 UI 파일
- 클래스 네이밍 규칙:
- `Section` 명칭은 사용하지 않는다.
- 파일 prefix로 역할이 구분되므로 class명에 `Page/Screen/Fragment/Widget` suffix를 붙이지 않는다.
- 라우터에서 직접 참조되는 진입 class만 public 허용
- 그 외 class와 헬퍼 함수는 private(`_`)를 기본으로 한다.
- `part/part of` 규칙:
- 기능 루트의 `pg_*.dart`에서 `part`로 `sc_/fg_/wd_` 파일을 연결
- 하위 파일은 해당 `pg_*.dart`를 `part of`로 참조

## UI 코드 작성 체크리스트 (필수)
- 새 UI 파일 생성 시 먼저 기능 경로(`app/lib/features/<feature>/...`)가 맞는지 확인한다.
- 파일 역할에 맞는 prefix(`pg_`, `sc_`, `fg_`, `wd_`)를 선택한다.
- `Section` 명칭은 사용하지 않는다.
- class명에 `Page/Screen/Fragment/Widget` suffix를 붙이지 않는다.
- 라우팅 진입 class 외에는 private(`_`)로 선언하고 `part/part of` 연결을 유지한다.
- 기존 규칙과 충돌하는 구조(`pages` 경로, `view/sections/widgets` 역할 폴더 분리)는 신규 코드에서 사용하지 않는다.

## 이미지 업로드 네이티브 설정 메모 (Android/iOS)
- 목적: 피드 작성/수정에서 갤러리 이미지 1장 선택 + 로컬 압축 저장 기능 지원

Android
- 파일: `app/android/app/build.gradle.kts`
- 반영 내용:
- `dependencies`에 `implementation("androidx.activity:activity:1.9.3")` 추가
- 이유: `image_picker`의 Android Photo Picker 브릿지 채널 안정성 확보

iOS
- 파일: `app/ios/Runner/Info.plist`
- 반영 내용:
- `NSPhotoLibraryUsageDescription` 키 추가
- 값: `피드에 이미지를 첨부하기 위해 사진 라이브러리 접근 권한이 필요합니다.`
- 이유: 갤러리 접근 권한 안내 문구(권한 요청 시 시스템에서 표시)

## 이미지 업로드 코드 구현 상세
- 대상 정책: `최대 1장`, `로컬 저장`, `압축 저장`, `탭으로 업로드/교체`

핵심 UI 위젯
- 파일: `app/lib/features/feed/create/wd_feed_editor_image.dart`
- `FeedEditorImage`:
- 입력: `imageLocalPath`, `onChanged`, `onError`
- 동작:
- 프리뷰 영역 탭 -> `_pickAndStoreImage()`
- 이미지 제거 버튼 탭 -> `onChanged(null)`
- 처리 중 오버레이 스피너 노출 (`_isProcessing`)
- `_pickAndStoreImage()`:
- `ImagePicker().pickImage(source: ImageSource.gallery)`로 갤러리 1장 선택
- 선택 성공 시 `_compressAndStore()` 호출
- 저장된 경로를 `onChanged(savedPath)`로 상위에 전달
- `_compressAndStore()`:
- 앱 문서 디렉터리 하위 `feed_images/` 생성
- 파일명: `feed_<timestamp>.jpg`
- `FlutterImageCompress.compressAndGetFile(...)`로 JPEG 압축 저장
- 압축 옵션: `quality: 78`, `minWidth: 1440`, `minHeight: 1440`
- 오류 처리:
- `MissingPluginException` / `PlatformException`을 사용자 메시지로 변환
- 디버그 로그 출력: `FeedEditorImage error: ...`
- `_ImagePreview`:
- 미선택 높이 `96`, 선택 높이 `172` (톤다운된 카드 UI)
- 안내 라벨: `Tap to upload` / `Tap to replace`
- 선택 상태에서 우상단 `X`로 제거 가능

Create/Edit 화면 연결
- 작성 연결 파일: `app/lib/features/feed/create/fg_create_feed_image.dart`
- `CreateFeedState.data.imageLocalPath`를 `FeedEditorImage`로 전달
- 변경 시 `CreateFeedCubit.setImageLocalPath(path)` 호출
- 수정 연결 파일: `app/lib/features/feed/edit/fg_edit_feed_image.dart`
- `EditFeedState.data.imageLocalPath`를 `FeedEditorImage`로 전달
- 변경 시 `EditFeedCubit.setImageLocalPath(path)` 호출

화면 배치 반영
- 작성 화면: `app/lib/features/feed/create/sc_create_feed.dart`
- 순서: `Intro -> Note -> Image -> Hashtag`
- 수정 화면: `app/lib/features/feed/edit/sc_edit_feed.dart`
- 순서: `Intro -> Note -> Image -> Hashtag`

페이지 import/part 연결
- 작성 페이지: `app/lib/features/feed/create/pg_create_feed.dart`
- `wd_feed_editor_image.dart` import
- `part 'fg_create_feed_image.dart';` 추가
- 수정 페이지: `app/lib/features/feed/edit/pg_edit_feed.dart`
- `wd_feed_editor_image.dart` import
- `part 'fg_edit_feed_image.dart';` 추가

패키지 의존성
- 파일: `app/pubspec.yaml`
- 추가:
- `image_picker: ^1.1.2`
- `flutter_image_compress: ^2.4.0`
- `path_provider: ^2.1.2`

안정화 메모
- Android `ImagePickerApi.pickImages` 채널 에러 대응으로 `androidx.activity` 명시:
- 파일: `app/android/app/build.gradle.kts`
- `implementation("androidx.activity:activity:1.9.3")`
- 플러그인 추가/업데이트 직후에는 `hot reload` 대신 앱 완전 재실행 필요

---

# 감정 쓰레기통 앱 기획 (v0.2)

작성일: 2026-02-15

**목표**
- 오프라인에서도 감정 기록 가능(Drift 로컬 DB)
- 온라인 연결 시 Supabase로 업로드/동기화
- 해소되면 체크해서 해소 시각만 기록

**핵심 플로우**
1. 어떤 일이 있었는지 입력
2. 그때 감정이 어땠는지 기록
3. 해소됨 체크 → 해소 시각 기록
4. 오프라인이면 로컬 저장, 온라인이면 업로드/동기화

**MVP 범위**
- 오프라인 로컬 저장(Drift)
- 온라인 저장(Supabase)
- 동기화 상태 표시(로컬 전용/업로드 대기/동기화 완료)
- 감정 기록(상황/감정/시간)
- 해소됨 체크(해소 시각 기록)
- 목록/검색(간단 텍스트 검색)

**데이터 모델(논리 모델, 저장 방식 독립)**

Entry
| 필드 | 타입 | 설명 |
| --- | --- | --- |
| id | string (uuid) | 항목 고유 ID |
| server_id | string (nullable) | Supabase 레코드 ID |
| created_at | datetime | 생성 시각 |
| updated_at | datetime | 수정 시각 |
| event_text | string | 어떤 일이 있었는지 |
| emotion | enum | 감정 타입 |
| resolved_at | datetime | 해소 처리 시각(없으면 미해소) |
| deleted_at | datetime | 삭제 시각(없으면 미삭제) |
| sync_status | enum | local_only / pending_upload / synced / conflict |
| last_synced_at | datetime | 마지막 동기화 시각 |

**감정 enum 목록(초안)**
- 화남
- 불안
- 슬픔
- 기쁨
- 짜증
- 두려움
- 피곤
- 무기력

**동기화 정책(초안)**
- 트리거: 앱 실행 시, 네트워크 복귀 시, 수동 동기화 버튼
- 업로드 우선: local_only/pending_upload 항목을 Supabase에 반영
- 다운로드: 서버 변경분을 로컬에 반영
- 충돌 처리: TBD (예: 최신 수정 우선, 사용자 선택)

**오프라인 UX(초안)**
- 작성 시 "오프라인 저장됨" 상태 표시
- 동기화 대기 큐 및 진행 상태 표시

**보안/계정(결정 필요)**
- 로그인 필수 여부: TBD
- 익명 모드 지원 여부: TBD

**오픈 질문**
- 충돌 정책: 최신 수정 우선 vs 사용자 선택
- 삭제 정책: 완전 삭제 vs 휴지통(복구 가능)
- 로그인/익명 시작 플로우

**코드 구조 메모**
- 긴 매핑 로직은 mixin으로 분리하고 with로 합성한다
- 예: Drift 로컬 datasource의 row<->model 매핑, FeedRepository의 동기화 관련 유틸
- 아키텍처 규칙(강제):
- View(UI) 레이어에서 UseCase를 직접 참조/호출하지 않는다.
- `feature_feed.dart` 같은 배럴 파일에서 UseCase를 export하지 않는다.
- UI 액션(조회/복원/삭제/동기화 등)은 반드시 Bloc/Cubit을 통해서만 실행한다.

---

## 피드 기능 이후 확장 제안 (v0.3)

### 우선순위 로드맵

단기(다음 스프린트)
- 반응(공감) 기능: 피드 진입 장벽을 낮추고 참여율을 올림
- 북마크(저장): 다시 보고 싶은 글을 모아 재방문율을 올림
- 피드 필터/정렬: 감정별/최신순/인기순으로 탐색 피로를 줄임

중기
- 댓글 기능: 피드백 루프 형성으로 커뮤니티 밀도 강화
- 신고/숨김/차단: 커뮤니티 안전성 확보
- 알림: 댓글/반응 수신으로 리텐션 강화

장기
- 추천 피드(개인화): 팔로우/관심 감정 기반으로 피드 품질 고도화
- 감정 인사이트: 주간 감정 추이, 자주 기록한 감정 요약 제공
- 콘텐츠 가이드: 업로드 전 민감 표현 경고/완화 가이드 제공

### 기능별 최소 구현 범위 (MVP 이후)

1. 반응(공감)
- 최소 구현
  - 항목당 공감 1종(토글)만 제공
  - 본인 반응 여부 + 총 반응 수 표시
- 확장 포인트
  - 다중 리액션(응원/공감/위로) 도입

2. 북마크
- 최소 구현
  - 북마크 추가/해제
  - 내 북마크 목록 화면
- 확장 포인트
  - 북마크 컬렉션(폴더) 기능

3. 댓글
- 최소 구현
  - 텍스트 댓글 작성/삭제
  - 본인 댓글만 삭제 가능
  - 댓글 수 표시
- 확장 포인트
  - 대댓글, 멘션, 댓글 좋아요

4. 신고/숨김/차단
- 최소 구현
  - 글 신고(사유 선택), 글 숨김, 사용자 차단
  - 차단한 사용자의 글은 피드에서 제외
- 확장 포인트
  - 관리자 검수 큐, 자동 제재 규칙

5. 알림
- 최소 구현
  - 내 글에 댓글/공감 발생 시 인앱 알림
  - 읽음 처리
- 확장 포인트
  - 푸시 알림, 알림 유형별 수신 설정

6. 추천 피드/인사이트
- 최소 구현
  - 최신 피드 + 감정 태그 기반 간단 추천
  - 주간 감정 분포(막대 차트)
- 확장 포인트
  - 개인 행동 기반 랭킹 모델, 회복 가이드 추천

### 데이터 모델 확장 초안

- `entry_reactions`
  - `id`, `entry_id`, `user_id`, `reaction_type`, `created_at`
  - 유니크 키: (`entry_id`, `user_id`, `reaction_type`)

- `entry_bookmarks`
  - `id`, `entry_id`, `user_id`, `created_at`
  - 유니크 키: (`entry_id`, `user_id`)

- `entry_comments`
  - `id`, `entry_id`, `user_id`, `content`, `created_at`, `deleted_at`

- `user_blocks`
  - `id`, `blocker_user_id`, `blocked_user_id`, `created_at`
  - 유니크 키: (`blocker_user_id`, `blocked_user_id`)

- `entry_reports`
  - `id`, `entry_id`, `reporter_user_id`, `reason`, `detail`, `created_at`, `status`

- `notifications`
  - `id`, `user_id`, `type`, `target_id`, `is_read`, `created_at`

### 결정 필요 항목
- 반응 종류를 1개(공감)로 시작할지, 2~3개로 시작할지
- 댓글 운영 정책(욕설 필터, 금칙어, 신고 임계치)
- 익명성 수준(닉네임 고정 여부, 프로필 공개 범위)
- 추천 피드 기준(최신 우선 vs 개인화 비중)
