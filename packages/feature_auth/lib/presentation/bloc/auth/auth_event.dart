import 'package:feature_auth/domain/entity/auth_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.started() = _AuthStarted;

  const factory AuthEvent.onAuthenticated(AuthUser authUser) = _OnAuthenticated;

  const factory AuthEvent.onUnAuthenticated() = _OnUnAuthenticated;
}
