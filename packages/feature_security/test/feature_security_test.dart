import 'package:feature_security/feature_security.dart';
import 'package:feature_security/src/data/datasource/secure_storage_security_datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('SecureStorageSecurityDataSource', () {
    late _MockFlutterSecureStorage secureStorage;
    late SecureStorageSecurityDataSource dataSource;

    setUp(() {
      secureStorage = _MockFlutterSecureStorage();
      dataSource = SecureStorageSecurityDataSource(
        secureStorage: secureStorage,
      );
    });

    test('saves password into secure storage', () async {
      when(
        () => secureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
          iOptions: any(named: 'iOptions'),
          aOptions: any(named: 'aOptions'),
          lOptions: any(named: 'lOptions'),
          wOptions: any(named: 'wOptions'),
          mOptions: any(named: 'mOptions'),
          webOptions: any(named: 'webOptions'),
        ),
      ).thenAnswer((_) async {});

      await dataSource.savePassword('1234');

      verify(
        () => secureStorage.write(
          key: SecureStorageSecurityDataSource.defaultPasswordKey,
          value: '1234',
          iOptions: null,
          aOptions: null,
          lOptions: null,
          wOptions: null,
          mOptions: null,
          webOptions: null,
        ),
      ).called(1);
    });

    test('verifies password with stored value', () async {
      when(
        () => secureStorage.read(
          key: any(named: 'key'),
          iOptions: any(named: 'iOptions'),
          aOptions: any(named: 'aOptions'),
          lOptions: any(named: 'lOptions'),
          wOptions: any(named: 'wOptions'),
          mOptions: any(named: 'mOptions'),
          webOptions: any(named: 'webOptions'),
        ),
      ).thenAnswer((_) async => '1234');

      final matched = await dataSource.verifyPassword('1234');

      expect(matched, isTrue);
    });

    test('throws when password is empty', () async {
      expect(
        () => dataSource.savePassword('  '),
        throwsA(isA<SecurityException>()),
      );
    });
  });
}
