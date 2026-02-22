import 'dart:async';

import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/core/constants/feed_limits.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/delete_feed_image_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/get_feed_entry_by_id_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/save_feed_image_use_case.dart';
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
    _saveImageUseCase = feedUseCase.saveFeedImage;
    _deleteImageUseCase = feedUseCase.deleteFeedImage;
    unawaited(_init());
  }

  final String _feedId;

  late final GetLocalFeedEntryByIdUseCase _getByIdUseCase;
  late final UpdateLocalFeedEntryUseCase _updateUseCase;
  late final SaveFeedImageUseCase _saveImageUseCase;
  late final DeleteFeedImageUseCase _deleteImageUseCase;
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
                  title: fetched.title,
                  hashtags: fetched.hashtags,
                  note: fetched.note,
                  imageLocalPath: fetched.imageLocalPath,
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
          title: state.data.title,
          hashtags: state.data.hashtags,
          note: text.trim(),
          imageLocalPath: state.data.imageLocalPath,
        ),
        failure: null,
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
        failure: null,
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
        failure: null,
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
        failure: null,
      ),
    );
  }

  Future<void> saveImageFromSourcePath(String sourcePath) async {
    if (!state.isEditing) return;
    final normalizedSourcePath = _normalizePath(sourcePath);
    if (normalizedSourcePath == null) return;

    final data = state.data;
    final existingPath = _normalizePath(data.imageLocalPath);
    emit(EditFeedState.loading(data));
    final savedResult = await _saveImageUseCase(normalizedSourcePath);
    await savedResult.fold(
      (failure) async => emit(EditFeedState.editing(data, failure: failure)),
      (savedPath) async {
        if (existingPath != null && existingPath != savedPath) {
          final deleteResult = await _deleteImageUseCase(existingPath);
          return deleteResult.fold(
            (failure) => emit(EditFeedState.editing(data, failure: failure)),
            (_) => emit(
              EditFeedState.editing((
                title: data.title,
                hashtags: data.hashtags,
                note: data.note,
                imageLocalPath: savedPath,
              )),
            ),
          );
        }
        emit(
          EditFeedState.editing((
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

    emit(EditFeedState.loading(data));
    final deletedResult = await _deleteImageUseCase(existingPath);
    deletedResult.fold(
      (failure) => emit(EditFeedState.editing(data, failure: failure)),
      (_) => emit(
        EditFeedState.editing((
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
    final title = _normalizeTitle(state.data.title);
    final hashtags = _normalizeHashtags(state.data.hashtags);
    final note = state.data.note.trim();
    final imageLocalPath = state.data.imageLocalPath?.trim();

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

    final normalizedImageLocalPath = imageLocalPath?.isEmpty == true
        ? null
        : imageLocalPath;
    final imageChanged =
        _initialEntry.imageLocalPath != normalizedImageLocalPath;
    final updatedEntry = _initialEntry.copyWith(
      title: title,
      hashtags: hashtags,
      note: note,
      imageLocalPath: normalizedImageLocalPath,
      imageRemotePath: imageChanged ? null : _initialEntry.imageRemotePath,
      imageRemoteUrl: imageChanged ? null : _initialEntry.imageRemoteUrl,
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
