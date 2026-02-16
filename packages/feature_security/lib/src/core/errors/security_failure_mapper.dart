import 'security_error.dart';
import 'security_exception.dart';
import 'security_failure.dart';

extension SecurityFailureMapper on Object {
  SecurityFailure toSecurityFailure([StackTrace? stackTrace]) {
    if (this is SecurityException) {
      final exception = this as SecurityException;
      return SecurityFailure.fromError(
        exception.error,
        cause: exception.cause ?? exception,
        stackTrace: exception.stackTrace ?? stackTrace,
      );
    }

    return SecurityFailure.fromError(
      SecurityError.unknown,
      cause: this,
      stackTrace: stackTrace,
    );
  }
}
