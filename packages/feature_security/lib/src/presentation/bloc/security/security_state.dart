part of 'security_bloc.dart';

@freezed
class SecurityState with _$SecurityState {
  const factory SecurityState.idle() = _IdleState;

  const factory SecurityState.loading() = _LoadingState;

  const factory SecurityState.locked({SecurityFailure? failure}) = _LockedState;

  const factory SecurityState.unlocked({
    SecurityFailure? failure,
    @Default(false) bool hasPassword,
  }) = _UnlockedState;
}

extension SecurityStateX on SecurityState {
  bool get isLoading => mapOrNull(loading: (_) => true) ?? false;

  bool get unLocked => mapOrNull(unlocked: (_) => true) ?? false;

  bool get hasPassword => maybeWhen(
    locked: (_) => true,
    unlocked: (_, hasPassword) => hasPassword,
    orElse: () => false,
  );

  bool get isUnlockedWithoutPassword => maybeWhen(
    unlocked: (_, hasPassword) => !hasPassword,
    orElse: () => false,
  );

  bool get isUnlockedWithPassword =>
      maybeWhen(unlocked: (_, hasPassword) => hasPassword, orElse: () => false);

  SecurityFailure? get failure =>
      mapOrNull(locked: (e) => e.failure, unlocked: (e) => e.failure);
}
