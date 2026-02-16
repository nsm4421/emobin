enum FeedError {
  invalidEntry(invalidEntryCode, invalidEntryMessage),
  entryNotFound(entryNotFoundCode, entryNotFoundMessage),
  storageFailure(storageFailureCode, storageFailureMessage),
  unknown(unknownCode, unknownMessage);

  const FeedError(this.code, this.message);

  final String code;
  final String message;

  static const invalidEntryCode = 'invalid_entry';
  static const invalidEntryMessage = 'Invalid feed entry.';

  static const entryNotFoundCode = 'entry_not_found';
  static const entryNotFoundMessage = 'Feed entry not found.';

  static const storageFailureCode = 'storage_failure';
  static const storageFailureMessage = 'Unable to store feed entry.';

  static const unknownCode = 'unknown';
  static const unknownMessage = 'Unknown feed error.';
}
