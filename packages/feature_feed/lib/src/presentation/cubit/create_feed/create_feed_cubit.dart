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
    : super(
        CreateFeedState.editing((
          hashtags: const <String>[],
          note: '',
          imageLocalPath: null,
        )),
      ) {
    _useCase = feedUseCase.createLocalEntry;
  }

  late final CreateLocalFeedEntryUseCase _useCase;

  void updateNote(String text) {
    if (!state.isEditing) return;
    emit(
      (state as _EditingState).copyWith(
        data: (
          hashtags: state.data.hashtags,
          note: text.trim(),
          imageLocalPath: state.data.imageLocalPath,
        ),
      ),
    );
  }

  void setHashtags(List<String> hashtags) {
    if (!state.isEditing) return;
    emit(
      (state as _EditingState).copyWith(
        data: (
          hashtags: _normalizeHashtags(hashtags),
          note: state.data.note,
          imageLocalPath: state.data.imageLocalPath,
        ),
      ),
    );
  }

  void clearHashtags() {
    if (!state.isEditing) return;
    emit(
      (state as _EditingState).copyWith(
        data: (
          hashtags: const <String>[],
          note: state.data.note,
          imageLocalPath: state.data.imageLocalPath,
        ),
      ),
    );
  }

  void setImageLocalPath(String? imageLocalPath) {
    if (!state.isEditing) return;
    emit(
      (state as _EditingState).copyWith(
        data: (
          hashtags: state.data.hashtags,
          note: state.data.note,
          imageLocalPath: imageLocalPath,
        ),
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
    final hashtags = _normalizeHashtags(data.hashtags);
    final note = data.note.trim();
    final imageLocalPath = data.imageLocalPath?.trim();

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
      hashtags: hashtags,
      note: note,
      imageLocalPath: imageLocalPath?.isEmpty == true ? null : imageLocalPath,
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

  List<String> _normalizeHashtags(List<String> hashtags) {
    return hashtags
        .map((tag) => tag.trim().replaceFirst(RegExp(r'^#+'), ''))
        .where((tag) => tag.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }
}
