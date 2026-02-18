import 'dart:async';

import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/get_feed_entry_by_id_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/update_feed_entry_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'edit_feed_cubit.freezed.dart';

part 'edit_feed_state.dart';

@injectable
class EditFeedCubit extends Cubit<EditFeedState> {
  EditFeedCubit(FeedUseCase feedUseCase, @factoryParam String feedId)
    : _feedId = feedId,
      super(EditFeedState.idle()) {
    _getByIdUseCase = feedUseCase.getById;
    _updateUseCase = feedUseCase.updateLocalEntry;
    unawaited(_init());
  }

  final String _feedId;

  late final GetLocalFeedEntryByIdUseCase _getByIdUseCase;
  late final UpdateLocalFeedEntryUseCase _updateUseCase;
  late final FeedEntry _initialEntry;

  Future<void> _init() async {
    await _getByIdUseCase
        .call(_feedId)
        .then(
          (res) => res.fold(
            (failure) => emit(EditFeedState.idle(failure: failure)),
            (fetched) {
              if (fetched == null) {
                emit(
                  EditFeedState.idle(
                    failure: const FeedFailure.entryNotFound(),
                  ),
                );
                return;
              }

              _initialEntry = fetched;
              emit(
                EditFeedState.editing((
                  emotion: fetched.emotion,
                  intensity: fetched.intensity,
                  note: fetched.note,
                )),
              );
            },
          ),
        );
  }

  void updateNote(String text) {
    if (!state.isEditing) return;
    emit(
      (state as _EditingState).copyWith(
        data: (
          emotion: state.data.emotion,
          intensity: state.data.intensity,
          note: text.trim(),
        ),
        failure: null,
      ),
    );
  }

  void setEmotion({required String emotion, int intensity = 1}) {
    if (!state.isEditing) return;
    emit(
      (state as _EditingState).copyWith(
        data: (emotion: emotion, intensity: intensity, note: state.data.note),
        failure: null,
      ),
    );
  }

  void clearEmotion() {
    if (!state.isEditing) return;
    emit(
      (state as _EditingState).copyWith(
        data: (emotion: null, intensity: 0, note: state.data.note),
        failure: null,
      ),
    );
  }

  // 저장
  Future<void> saveEntry() async {
    final emotion = state.data.emotion?.trim();
    final note = state.data.note.trim();
    final intensity = state.data.intensity;

    if (note.isEmpty) {
      emit(
        EditFeedState.editing(
          state.data,
          failure: const FeedFailure.invalidEntry(),
        ),
      );
      return;
    }

    emit(EditFeedState.loading(state.data));

    final updatedEntry = _initialEntry.copyWith(
      emotion: emotion?.isEmpty == true ? null : emotion,
      note: note,
      intensity: intensity,
      isDraft: false,
    );

    await _updateUseCase
        .call(updatedEntry)
        .then(
          (res) => res.fold(
            (failure) =>
                emit(EditFeedState.editing(state.data, failure: failure)),
            (updated) {
              emit(EditFeedState.updated(updated));
            },
          ),
        );
  }

  void reset() {
    emit(EditFeedState.editing(state.data));
  }
}
