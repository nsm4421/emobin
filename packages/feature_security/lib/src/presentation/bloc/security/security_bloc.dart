import 'package:feature_security/src/core/errors/security_failure.dart';
import 'package:feature_security/src/domain/usecase/security_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'security_event.dart';

part 'security_state.dart';

part 'security_bloc.freezed.dart';

@lazySingleton
class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  SecurityBloc(this._securityUseCase) : super(const SecurityState.idle()) {
    on<SecurityEvent>(_onEvent);
  }

  final SecurityUseCase _securityUseCase;

  Future<void> _onEvent(
    SecurityEvent event,
    Emitter<SecurityState> emit,
  ) async {
    await event.when(
      started: () async {
        emit(const SecurityState.loading());
        await _securityUseCase.hasLocalPassword.call().then(
          (res) => res.fold(
            (failure) => emit(const SecurityState.idle()),
            (hasPassword) => emit(
              hasPassword
                  ? const SecurityState.locked()
                  : const SecurityState.unlocked(hasPassword: false),
            ),
          ),
        );
      },
      savePasswordRequested: (password) async {
        emit(const SecurityState.loading());
        await _securityUseCase.saveLocalPassword
            .call(password)
            .then(
              (res) async => res.fold(
                (failure) async =>
                    emit(SecurityState.unlocked(failure: failure)),
                (_) async => emit(const SecurityState.unlocked(hasPassword: true)),
              ),
            );
      },
      verifyPasswordRequested: (password) async {
        emit(const SecurityState.loading());
        await _securityUseCase.verifyLocalPassword
            .call(password)
            .then(
              (res) => res.fold(
                (failure) => emit(SecurityState.locked(failure: failure)),
                (matched) => emit(
                  matched
                      ? const SecurityState.unlocked(hasPassword: true)
                      : const SecurityState.locked(),
                ),
              ),
            );
      },
      deletePasswordRequested: () async {
        emit(const SecurityState.loading());
        await _securityUseCase.deleteLocalPassword.call().then(
          (res) => res.fold(
            (failure) => emit(SecurityState.locked(failure: failure)),
            (_) => emit(const SecurityState.unlocked(hasPassword: false)),
          ),
        );
      },
    );
  }
}
