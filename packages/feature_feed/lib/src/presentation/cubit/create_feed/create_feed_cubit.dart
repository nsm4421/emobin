import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/entity/feed_entry_draft.dart';
import 'package:feature_feed/src/domain/usecase/feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/create_feed_entry_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'create_feed_cubit.freezed.dart';

part 'create_feed_state.dart';

@injectable
class CreateFeedCubit extends Cubit<CreateFeedState> {
  CreateFeedCubit(FeedUseCase feedUseCase)
    : super(CreateFeedState.editing((emotion: null, intensity: 0, note: ''))) {
    _useCase = feedUseCase.createLocalEntry;
  }

  late final CreateLocalFeedEntryUseCase _useCase;

  void updateNote(String text) {
    if (!state.isEditing) return;
    emit(
      (state as _EditingState).copyWith(
        data: (
          emotion: state.data.emotion,
          intensity: state.data.intensity,
          note: text.trim(),
        ),
      ),
    );
  }

  void setEmotion({required String emotion, int intensity = 1}) {
    if (!state.isEditing) return;
    emit(
      (state as _EditingState).copyWith(
        data: (emotion: emotion, intensity: intensity, note: state.data.note),
      ),
    );
  }

  void clearEmotion() {
    if (!state.isEditing) return;
    emit(
      (state as _EditingState).copyWith(
        data: (emotion: null, intensity: 0, note: state.data.note),
      ),
    );
  }

  // 저장
  Future<void> saveEntry() async {
    await _saveInLocal(data: state.data, isDraft: false);
  }

  // 임시저장
  Future<void> saveDraft() async {
    await _saveInLocal(data: state.data, isDraft: true);
  }

  Future<void> _saveInLocal({
    required CreateFeedData data,
    required bool isDraft,
  }) async {
    final emotion = data.emotion?.trim();
    final note = data.note.trim();
    final intensity = data.intensity;

    if (!isDraft && note.isEmpty) {
      emit(
        CreateFeedState.editing(
          data,
          failure: const FeedFailure.invalidEntry(),
        ),
      );
      return;
    }

    emit(CreateFeedState.loading(data));

    final draft = FeedEntryDraft(
      emotion: emotion?.isEmpty == true ? null : emotion,
      note: note,
      intensity: intensity,
      isDraft: isDraft,
    );

    await _useCase
        .call(draft)
        .then(
          (res) => res.fold(
            (failure) => emit(CreateFeedState.editing(data, failure: failure)),
            (entry) =>
                emit(CreateFeedState.created(isDraft: isDraft, created: entry)),
          ),
        );
  }

  void reset() {
    emit(CreateFeedState.editing(state.data));
  }
}
