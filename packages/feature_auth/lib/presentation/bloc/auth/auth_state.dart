import 'package:feature_auth/data/model/auth_user_model.dart';
import 'package:feature_auth/domain/entity/auth_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:feature_auth/core/constants/auth_status.dart';

part 'auth_state.freezed.dart';

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
