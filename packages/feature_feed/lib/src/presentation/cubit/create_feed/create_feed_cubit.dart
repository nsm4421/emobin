import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/core/constants/feed_limits.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/entity/feed_entry_draft.dart';
import 'package:feature_feed/src/domain/usecase/feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/create_feed_entry_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/delete_feed_image_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/save_feed_image_use_case.dart';
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
          title: null,
          hashtags: const <String>[],
          note: '',
          imageLocalPath: null,
        )),
      ) {
    _useCase = feedUseCase.createLocalEntry;
    _saveImageUseCase = feedUseCase.saveFeedImage;
    _deleteImageUseCase = feedUseCase.deleteFeedImage;
  }

  late final CreateLocalFeedEntryUseCase _useCase;
  late final SaveFeedImageUseCase _saveImageUseCase;
  late final DeleteFeedImageUseCase _deleteImageUseCase;

  void updateNote(String text) {
    if (!state.isEditing) return;
    emit(
      (state as _EditingState).copyWith(
        data: (
          title: state.data.title,
          hashtags: state.data.hashtags,
          note: text.trim(),
          imageLocalPath: state.data.imageLocalPath,
        ),
      ),
    );
  }

  void updateTitle(String text) {
    if (!state.isEditing) return;
    emit(
      (state as _EditingState).copyWith(
        data: (
          title: _normalizeTitle(text),
          hashtags: state.data.hashtags,
          note: state.data.note,
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
          title: state.data.title,
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
          title: state.data.title,
          hashtags: const <String>[],
          note: state.data.note,
          imageLocalPath: state.data.imageLocalPath,
        ),
      ),
    );
  }

  Future<void> saveImageFromSourcePath(String sourcePath) async {
    if (!state.isEditing) return;
    final normalizedSourcePath = _normalizePath(sourcePath);
    if (normalizedSourcePath == null) return;

    final data = state.data;
    final existingPath = _normalizePath(data.imageLocalPath);
    emit(CreateFeedState.loading(data));
    final savedResult = await _saveImageUseCase(normalizedSourcePath);
    await savedResult.fold(
      (failure) async => emit(CreateFeedState.editing(data, failure: failure)),
      (savedPath) async {
        if (existingPath != null && existingPath != savedPath) {
          final deleteResult = await _deleteImageUseCase(existingPath);
          return deleteResult.fold(
            (failure) => emit(CreateFeedState.editing(data, failure: failure)),
            (_) => emit(
              CreateFeedState.editing((
                title: data.title,
                hashtags: data.hashtags,
                note: data.note,
                imageLocalPath: savedPath,
              )),
            ),
          );
        }
        emit(
          CreateFeedState.editing((
            title: data.title,
            hashtags: data.hashtags,
            note: data.note,
            imageLocalPath: savedPath,
          )),
        );
      },
    );
  }

  Future<void> removeImage() async {
    if (!state.isEditing) return;

    final data = state.data;
    final existingPath = _normalizePath(data.imageLocalPath);
    if (existingPath == null) return;

    emit(CreateFeedState.loading(data));
    final deletedResult = await _deleteImageUseCase(existingPath);
    deletedResult.fold(
      (failure) => emit(CreateFeedState.editing(data, failure: failure)),
      (_) => emit(
        CreateFeedState.editing((
          title: data.title,
          hashtags: data.hashtags,
          note: data.note,
          imageLocalPath: null,
        )),
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
    final title = _normalizeTitle(data.title);
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
      title: title,
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

  String? _normalizePath(String? raw) {
    final normalized = raw?.trim();
    if (normalized == null || normalized.isEmpty) return null;
    return normalized;
  }

  String? _normalizeTitle(String? raw) {
    final normalized = raw?.trim();
    if (normalized == null || normalized.isEmpty) return null;
    if (normalized.length <= feedTitleMaxLength) return normalized;
    return normalized.substring(0, feedTitleMaxLength);
  }
}
