import 'package:feature_auth/feature_auth.dart'
    show
        AuthDataSource,
        AuthException,
        AuthStatus,
        AuthUserModel,
        DataSourceAuthStreamPayload,
        ProfileModel;
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

part 'supabase_auth_exception_mapper.dart';

@LazySingleton(as: AuthDataSource)
class SupabaseAuthDataSource
    with SupabaseAuthExceptionMapper
    implements AuthDataSource {
  SupabaseAuthDataSource(this._client);

  final sb.SupabaseClient _client;

  static const String _profilesTable = 'profiles';

  @override
  Stream<DataSourceAuthStreamPayload> authStatus() async* {
    yield _payloadFromUser(_client.auth.currentUser);
    yield* _client.auth.onAuthStateChange.map((state) {
      final user = state.session?.user;
      return _payloadFromUser(user);
    });
  }

  @override
  Future<AuthUserModel> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final userMetadata = {'username': username};
      final signUpUser = await _client.auth
          .signUp(email: email, password: password, data: userMetadata)
          .then((res) => res.user);
      if (signUpUser == null) throw const AuthException.unknown();
      return _mapUser(signUpUser);
    } catch (error, stackTrace) {
      throw _mapAuthException(error, stackTrace);
    }
  }

  @override
  Future<AuthUserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final signInUser = await _client.auth
          .signInWithPassword(email: email, password: password)
          .then((res) => res.user);
      if (signInUser == null) throw const AuthException.invalidCredentials();
      return _mapUser(signInUser);
    } catch (error, stackTrace) {
      throw _mapAuthException(error, stackTrace);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error, stackTrace) {
      throw _mapAuthException(error, stackTrace);
    }
  }

  @override
  Future<void> deleteAccount() async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) throw const AuthException.notAuthenticated();
    try {
      await _client.from(_profilesTable).delete().eq('id', currentUser.id);
      await _client.auth.signOut();
    } catch (error, stackTrace) {
      throw _mapAuthException(error, stackTrace);
    }
  }

  @override
  Future<ProfileModel> updateProfile({String? bio, String? avatarUrl}) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) throw const AuthException.notAuthenticated();

      final profile = await _client
          .from(_profilesTable)
          .select()
          .eq('id', currentUser.id)
          .single();

      final updateData = <String, dynamic>{
        ...profile,
        if (bio != null) 'bio': bio,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      };

      return await _client
          .from(_profilesTable)
          .update(updateData)
          .eq('id', currentUser.id)
          .select()
          .single()
          .then(ProfileModel.fromJson);
    } catch (error, stackTrace) {
      throw _mapAuthException(error, stackTrace);
    }
  }

  DataSourceAuthStreamPayload _payloadFromUser(sb.User? user) {
    if (user == null) {
      return (status: AuthStatus.unauthenticated, user: null);
    }
    return (status: AuthStatus.authenticated, user: _mapUser(user));
  }

  AuthUserModel _mapUser(sb.User user) {
    return AuthUserModel(
      id: user.id,
      email: user.email,
      phone: user.phone,
      createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(user.updatedAt ?? '') ?? DateTime.now(),
      userMetadata: user.userMetadata ?? {},
    );
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
