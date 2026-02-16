import 'package:core/core.dart';

import 'security_error.dart';

class SecurityFailure extends Failure {
  final SecurityError error;

  const SecurityFailure._(
    this.error, {
    required super.message,
    required super.code,
    super.cause,
    super.stackTrace,
  });

  const SecurityFailure.emptyPassword({Object? cause, StackTrace? stackTrace})
    : this._(
        SecurityError.emptyPassword,
        message: SecurityError.emptyPasswordMessage,
        code: SecurityError.emptyPasswordCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const SecurityFailure.storageFailure({Object? cause, StackTrace? stackTrace})
    : this._(
        SecurityError.storageFailure,
        message: SecurityError.storageFailureMessage,
        code: SecurityError.storageFailureCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const SecurityFailure.unknown({Object? cause, StackTrace? stackTrace})
    : this._(
        SecurityError.unknown,
        message: SecurityError.unknownMessage,
        code: SecurityError.unknownCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  factory SecurityFailure.fromError(
    SecurityError error, {
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return SecurityFailure._(
      error,
      message: error.message,
      code: error.code,
      cause: cause,
      stackTrace: stackTrace,
    );
  }
}
