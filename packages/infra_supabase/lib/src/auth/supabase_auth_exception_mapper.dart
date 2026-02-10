part of 'supabase_auth_datasource.dart';

mixin SupabaseAuthExceptionMapper {
  AuthException _mapAuthException(Object error, [StackTrace? stackTrace]) {
    if (error is AuthException) {
      return error;
    }

    if (error is sb.AuthApiException) {
      return _mapAuthApiException(error, stackTrace);
    }

    if (error is sb.PostgrestException) {
      return _mapPostgrestException(error, stackTrace);
    }

    return AuthException.unknown(cause: error, stackTrace: stackTrace);
  }

  AuthException _mapAuthApiException(
    sb.AuthApiException error,
    StackTrace? stackTrace,
  ) {
    final message = error.message.toLowerCase();

    if (message.contains('email') && message.contains('already')) {
      return AuthException.emailAlreadyInUse(
        cause: error,
        stackTrace: stackTrace,
      );
    }

    if (message.contains('invalid login') ||
        message.contains('invalid credentials')) {
      return AuthException.invalidCredentials(
        cause: error,
        stackTrace: stackTrace,
      );
    }

    if (message.contains('user not found')) {
      return AuthException.accountNotFound(
        cause: error,
        stackTrace: stackTrace,
      );
    }

    if (message.contains('password')) {
      return AuthException.invalidPassword(
        cause: error,
        stackTrace: stackTrace,
      );
    }

    if (message.contains('email')) {
      return AuthException.invalidEmail(cause: error, stackTrace: stackTrace);
    }

    return AuthException.unknown(cause: error, stackTrace: stackTrace);
  }

  AuthException _mapPostgrestException(
    sb.PostgrestException error,
    StackTrace? stackTrace,
  ) {
    final message = error.message.toLowerCase();

    if (message.contains('not authenticated')) {
      return AuthException.notAuthenticated(
        cause: error,
        stackTrace: stackTrace,
      );
    }

    return AuthException.unknown(cause: error, stackTrace: stackTrace);
  }
}
