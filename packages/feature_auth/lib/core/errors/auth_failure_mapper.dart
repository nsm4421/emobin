import 'auth_error.dart';
import 'auth_exception.dart';
import 'auth_failure.dart';

extension AuthFailureMapper on Object {
  AuthFailure toAuthFailure([StackTrace? stackTrace]) {
    if (this is AuthException) {
      final exception = this as AuthException;
      return AuthFailure.fromError(
        exception.error,
        cause: exception.cause ?? exception,
        stackTrace: exception.stackTrace ?? stackTrace,
      );
    }

    return AuthFailure.fromError(
      AuthError.unknown,
      cause: this,
      stackTrace: stackTrace,
    );
  }
}
