part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.authenticated(AuthUser authUser) = _Authenticated;

  const factory AuthState.unAuthenticated() = _UnAuthenticated;

  const factory AuthState.unKnown() = _UnKnown;
}

extension AuthStateX on AuthState {
  AuthStatus get status => map(
    authenticated: (_) => AuthStatus.authenticated,
    unAuthenticated: (_) => AuthStatus.unauthenticated,
    unKnown: (_) => AuthStatus.unknown,
  );

  AuthUser? get authUser => mapOrNull(authenticated: (e) => e.authUser);
}
