import 'dart:async';

import 'package:injectable/injectable.dart';

import 'package:feature_auth/core/constants/auth_status.dart';
import 'package:feature_auth/data/datasource/auth_datasource.dart';
import 'package:feature_auth/data/model/auth_user_model.dart';
import 'package:feature_auth/data/model/profile_model.dart';

@LazySingleton(as: AuthDataSource)
class MockAuthDataSource implements AuthDataSource {
  final StreamController<DataSourceAuthStreamPayload> _statusController =
      StreamController<DataSourceAuthStreamPayload>.broadcast();
  AuthStatus _currentStatus = AuthStatus.unauthenticated;

  final Map<String, _MockAccount> _accountsByEmail = {};
  _MockAccount? _currentAccount;
  int _idSeed = 0;

  @override
  Stream<DataSourceAuthStreamPayload> authStatus() async* {
    yield (status: _currentStatus, user: _currentAccount?.user);
    yield* _statusController.stream;
  }

  @override
  Future<AuthUserModel> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    _assertEmail(normalizedEmail);
    _assertPassword(password);

    final existing = _accountsByEmail[normalizedEmail];
    if (existing != null) {
      throw StateError('Email already in use.');
    }

    final now = DateTime.now();
    final id = _nextId();
    final user = AuthUserModel(
      id: id,
      email: normalizedEmail,
      phone: null,
      createdAt: now,
      updatedAt: now,
      userMetadata: const <String, dynamic>{},
    );
    final profile = ProfileModel(
      id: id,
      username: _deriveUsername(normalizedEmail, id),
      avatarUrl: null,
      bio: null,
      createdAt: now,
      updatedAt: now,
    );

    final account = _MockAccount(
      id: id,
      email: normalizedEmail,
      password: password,
      user: user,
      profile: profile,
    );
    _accountsByEmail[normalizedEmail] = account;
    _currentAccount = account;
    _setStatus(AuthStatus.authenticated);
    return user;
  }

  @override
  Future<AuthUserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    final account = _accountsByEmail[normalizedEmail];
    if (account == null) {
      throw StateError('Account not found.');
    }
    if (account.deletedAt != null) {
      throw StateError('Account is deleted.');
    }
    if (account.password != password) {
      throw StateError('Invalid credentials.');
    }

    _currentAccount = account;
    _setStatus(AuthStatus.authenticated);
    return account.user;
  }

  @override
  Future<void> signOut() async {
    _currentAccount = null;
    _setStatus(AuthStatus.unauthenticated);
  }

  @override
  Future<void> deleteAccount() async {
    final account = _currentAccount;
    if (account == null) {
      throw StateError('Not authenticated.');
    }
    if (account.deletedAt != null) {
      throw StateError('Account already deleted.');
    }

    final now = DateTime.now();
    account.deletedAt = now;
    account.profile = account.profile.copyWith(updatedAt: now);
    _currentAccount = null;
    _setStatus(AuthStatus.unauthenticated);
  }

  @override
  Future<ProfileModel> updateProfile({String? bio, String? avatarUrl}) async {
    final account = _currentAccount;
    if (account == null) {
      throw StateError('Not authenticated.');
    }
    if (account.deletedAt != null) {
      throw StateError('Account is deleted.');
    }

    final now = DateTime.now();
    account.profile = account.profile.copyWith(
      bio: bio ?? account.profile.bio,
      avatarUrl: avatarUrl ?? account.profile.avatarUrl,
      updatedAt: now,
    );
    return account.profile;
  }

  void _setStatus(AuthStatus status) {
    _currentStatus = status;
    _statusController.add((status: status, user: _currentAccount?.user));
  }

  String _nextId() => 'mock_${++_idSeed}';

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  void _assertEmail(String email) {
    if (email.isEmpty || !email.contains('@')) {
      throw ArgumentError.value(email, 'email', 'Invalid email.');
    }
  }

  void _assertPassword(String password) {
    if (password.isEmpty) {
      throw ArgumentError.value(password, 'password', 'Invalid password.');
    }
  }

  String _deriveUsername(String email, String id) {
    final at = email.indexOf('@');
    final base = at > 0 ? email.substring(0, at) : email;
    final sanitized = base.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
    return sanitized.isEmpty ? 'user_$id' : sanitized;
  }
}

class _MockAccount {
  final String id;
  final String email;
  final String password;
  final AuthUserModel user;
  ProfileModel profile;
  DateTime? deletedAt;

  _MockAccount({
    required this.id,
    required this.email,
    required this.password,
    required this.user,
    required this.profile,
    this.deletedAt,
  });
}
