abstract interface class SecurityDataSource {
  Future<void> savePassword(String password);

  Future<void> savePasswordHint(String hint);

  Future<bool> verifyPassword(String password);

  Future<String?> getPasswordHint();

  Future<void> deletePasswordHint();

  Future<void> deletePassword();

  Future<bool> hasPassword();
}
