import 'package:core/core.dart';

import 'auth_error.dart';

class AuthFailure extends Failure {
  final AuthError error;

  const AuthFailure._(
    this.error, {
    required String message,
    required String code,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         code: code,
         cause: cause,
         stackTrace: stackTrace,
       );

  const AuthFailure.invalidEmail({Object? cause, StackTrace? stackTrace})
    : this._(
        AuthError.invalidEmail,
        message: AuthError.invalidEmailMessage,
        code: AuthError.invalidEmailCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const AuthFailure.invalidPassword({Object? cause, StackTrace? stackTrace})
    : this._(
        AuthError.invalidPassword,
        message: AuthError.invalidPasswordMessage,
        code: AuthError.invalidPasswordCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const AuthFailure.emailAlreadyInUse({Object? cause, StackTrace? stackTrace})
    : this._(
        AuthError.emailAlreadyInUse,
        message: AuthError.emailAlreadyInUseMessage,
        code: AuthError.emailAlreadyInUseCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const AuthFailure.accountNotFound({Object? cause, StackTrace? stackTrace})
    : this._(
        AuthError.accountNotFound,
        message: AuthError.accountNotFoundMessage,
        code: AuthError.accountNotFoundCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const AuthFailure.accountDeleted({Object? cause, StackTrace? stackTrace})
    : this._(
        AuthError.accountDeleted,
        message: AuthError.accountDeletedMessage,
        code: AuthError.accountDeletedCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const AuthFailure.invalidCredentials({Object? cause, StackTrace? stackTrace})
    : this._(
        AuthError.invalidCredentials,
        message: AuthError.invalidCredentialsMessage,
        code: AuthError.invalidCredentialsCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const AuthFailure.notAuthenticated({Object? cause, StackTrace? stackTrace})
    : this._(
        AuthError.notAuthenticated,
        message: AuthError.notAuthenticatedMessage,
        code: AuthError.notAuthenticatedCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const AuthFailure.unknown({Object? cause, StackTrace? stackTrace})
    : this._(
        AuthError.unknown,
        message: AuthError.unknownMessage,
        code: AuthError.unknownCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  factory AuthFailure.fromError(
    AuthError error, {
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return AuthFailure._(
      error,
      message: error.message,
      code: error.code,
      cause: cause,
      stackTrace: stackTrace,
    );
  }
}
