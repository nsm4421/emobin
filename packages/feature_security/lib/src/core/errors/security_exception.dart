import 'package:core/core.dart';

import 'security_error.dart';

class SecurityException extends AppException {
  final SecurityError error;

  const SecurityException._(
    this.error, {
    required super.message,
    required super.code,
    super.cause,
    super.stackTrace,
  });

  const SecurityException.emptyPassword({Object? cause, StackTrace? stackTrace})
    : this._(
        SecurityError.emptyPassword,
        message: SecurityError.emptyPasswordMessage,
        code: SecurityError.emptyPasswordCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const SecurityException.storageFailure({
    Object? cause,
    StackTrace? stackTrace,
  }) : this._(
         SecurityError.storageFailure,
         message: SecurityError.storageFailureMessage,
         code: SecurityError.storageFailureCode,
         cause: cause,
         stackTrace: stackTrace,
       );

  const SecurityException.unknown({Object? cause, StackTrace? stackTrace})
    : this._(
        SecurityError.unknown,
        message: SecurityError.unknownMessage,
        code: SecurityError.unknownCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  factory SecurityException.fromError(
    SecurityError error, {
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return SecurityException._(
      error,
      message: error.message,
      code: error.code,
      cause: cause,
      stackTrace: stackTrace,
    );
  }
}
