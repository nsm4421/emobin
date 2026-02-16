abstract interface class SecurityDataSource {
  Future<void> savePassword(String password);

  Future<bool> verifyPassword(String password);

  Future<void> deletePassword();

  Future<bool> hasPassword();
}
