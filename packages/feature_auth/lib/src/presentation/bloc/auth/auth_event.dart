part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.started() = _AuthStarted;

  const factory AuthEvent.onAuthenticated(AuthUser authUser) = _OnAuthenticated;

  const factory AuthEvent.onUnAuthenticated() = _OnUnAuthenticated;
}
