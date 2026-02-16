enum SecurityError {
  emptyPassword(emptyPasswordCode, emptyPasswordMessage),
  storageFailure(storageFailureCode, storageFailureMessage),
  unknown(unknownCode, unknownMessage);

  const SecurityError(this.code, this.message);

  final String code;
  final String message;

  static const emptyPasswordCode = 'empty_password';
  static const emptyPasswordMessage = 'Password cannot be empty.';

  static const storageFailureCode = 'storage_failure';
  static const storageFailureMessage = 'Unable to access secure storage.';

  static const unknownCode = 'unknown';
  static const unknownMessage = 'Unknown security error.';
}
