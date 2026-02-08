enum AuthError {
  invalidEmail(invalidEmailCode, invalidEmailMessage),
  invalidPassword(invalidPasswordCode, invalidPasswordMessage),
  emailAlreadyInUse(emailAlreadyInUseCode, emailAlreadyInUseMessage),
  accountNotFound(accountNotFoundCode, accountNotFoundMessage),
  accountDeleted(accountDeletedCode, accountDeletedMessage),
  invalidCredentials(invalidCredentialsCode, invalidCredentialsMessage),
  notAuthenticated(notAuthenticatedCode, notAuthenticatedMessage),
  unknown(unknownCode, unknownMessage);

  const AuthError(this.code, this.message);

  final String code;
  final String message;

  static const invalidEmailCode = 'invalid_email';
  static const invalidEmailMessage = 'Invalid email.';

  static const invalidPasswordCode = 'invalid_password';
  static const invalidPasswordMessage = 'Invalid password.';

  static const emailAlreadyInUseCode = 'email_already_in_use';
  static const emailAlreadyInUseMessage = 'Email already in use.';

  static const accountNotFoundCode = 'account_not_found';
  static const accountNotFoundMessage = 'Account not found.';

  static const accountDeletedCode = 'account_deleted';
  static const accountDeletedMessage = 'Account is deleted.';

  static const invalidCredentialsCode = 'invalid_credentials';
  static const invalidCredentialsMessage = 'Invalid credentials.';

  static const notAuthenticatedCode = 'not_authenticated';
  static const notAuthenticatedMessage = 'Not authenticated.';

  static const unknownCode = 'unknown';
  static const unknownMessage = 'Unknown auth error.';
}
