import 'package:core/core.dart';

import 'auth_error.dart';

class AuthException extends AppException {
  final AuthError error;

  const AuthException._(
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

  const AuthException.invalidEmail({Object? cause, StackTrace? stackTrace})
    : this._(
        AuthError.invalidEmail,
        message: AuthError.invalidEmailMessage,
        code: AuthError.invalidEmailCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const AuthException.invalidPassword({Object? cause, StackTrace? stackTrace})
    : this._(
        AuthError.invalidPassword,
        message: AuthError.invalidPasswordMessage,
        code: AuthError.invalidPasswordCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const AuthException.emailAlreadyInUse({Object? cause, StackTrace? stackTrace})
    : this._(
        AuthError.emailAlreadyInUse,
        message: AuthError.emailAlreadyInUseMessage,
        code: AuthError.emailAlreadyInUseCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const AuthException.accountNotFound({Object? cause, StackTrace? stackTrace})
    : this._(
        AuthError.accountNotFound,
        message: AuthError.accountNotFoundMessage,
        code: AuthError.accountNotFoundCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const AuthException.accountDeleted({Object? cause, StackTrace? stackTrace})
    : this._(
        AuthError.accountDeleted,
        message: AuthError.accountDeletedMessage,
        code: AuthError.accountDeletedCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const AuthException.invalidCredentials({
    Object? cause,
    StackTrace? stackTrace,
  }) : this._(
         AuthError.invalidCredentials,
         message: AuthError.invalidCredentialsMessage,
         code: AuthError.invalidCredentialsCode,
         cause: cause,
         stackTrace: stackTrace,
       );

  const AuthException.notAuthenticated({Object? cause, StackTrace? stackTrace})
    : this._(
        AuthError.notAuthenticated,
        message: AuthError.notAuthenticatedMessage,
        code: AuthError.notAuthenticatedCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const AuthException.unknown({Object? cause, StackTrace? stackTrace})
    : this._(
        AuthError.unknown,
        message: AuthError.unknownMessage,
        code: AuthError.unknownCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  factory AuthException.fromError(
    AuthError error, {
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return AuthException._(
      error,
      message: error.message,
      code: error.code,
      cause: cause,
      stackTrace: stackTrace,
    );
  }
}
