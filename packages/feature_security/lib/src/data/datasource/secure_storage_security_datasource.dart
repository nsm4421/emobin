import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'package:feature_security/src/core/errors/security_exception.dart';

import 'security_datasource.dart';

@LazySingleton(as: SecurityDataSource)
class SecureStorageSecurityDataSource implements SecurityDataSource {
  SecureStorageSecurityDataSource({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  static const String defaultPasswordKey = 'local_password';

  final FlutterSecureStorage _secureStorage;
  final String key = defaultPasswordKey;

  @override
  Future<void> savePassword(String password) async {
    if (password.trim().isEmpty) {
      throw const SecurityException.emptyPassword();
    }

    try {
      await _secureStorage.write(key: key, value: password);
    } catch (error, stackTrace) {
      throw SecurityException.storageFailure(
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<bool> verifyPassword(String password) async {
    try {
      final stored = await _secureStorage.read(key: key);
      if (stored == null || stored.isEmpty) {
        return false;
      }
      return stored == password;
    } catch (error, stackTrace) {
      throw SecurityException.storageFailure(
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> deletePassword() async {
    try {
      await _secureStorage.delete(key: key);
    } catch (error, stackTrace) {
      throw SecurityException.storageFailure(
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<bool> hasPassword() async {
    try {
      final stored = await _secureStorage.read(key: key);
      return (stored ?? '').isNotEmpty;
    } catch (error, stackTrace) {
      throw SecurityException.storageFailure(
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}
