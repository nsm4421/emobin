enum FeedSyncStatus {
  /// 로컬에만 존재하는 상태.
  /// 예: draft 생성, sync_status 파싱 실패/누락 시 기본값.
  localOnly('local_only'),

  /// 원격 업로드가 필요한 상태.
  /// 예: 신규 작성(draft 아님), synced 이후 수정/삭제 발생.
  pendingUpload('pending_upload'),

  /// 원격 동기화가 완료된 상태.
  /// 업로드 성공 후 lastSyncedAt 갱신과 함께 설정된다.
  synced('synced'),

  /// 로컬/원격 충돌 상태를 표현하기 위한 예약 값.
  /// 현재 구현에서는 상태 전이 로직에서 직접 세팅되지 않는다.
  conflict('conflict');

  const FeedSyncStatus(this.value);

  final String value;

  static FeedSyncStatus fromString(String? value) {
    if (value == null || value.isEmpty) {
      return FeedSyncStatus.localOnly;
    }
    for (final status in FeedSyncStatus.values) {
      if (status.value == value || status.name == value) {
        return status;
      }
    }
    return FeedSyncStatus.localOnly;
  }
}
