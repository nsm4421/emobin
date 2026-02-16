enum FeedSyncStatus {
  localOnly('local_only'),
  pendingUpload('pending_upload'),
  synced('synced'),
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
