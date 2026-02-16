part of 'security_bloc.dart';

@freezed
class SecurityEvent with _$SecurityEvent {
  const factory SecurityEvent.started() = _StartedEvent;

  const factory SecurityEvent.savePasswordRequested(String password) =
      _SavePasswordRequestedEvent;

  const factory SecurityEvent.verifyPasswordRequested(String password) =
      _VerifyPasswordRequestedEvent;

  const factory SecurityEvent.deletePasswordRequested() =
      _DeletePasswordRequestedEvent;
}
