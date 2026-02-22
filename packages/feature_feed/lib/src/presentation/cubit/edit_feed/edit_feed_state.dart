part of 'edit_feed_cubit.dart';

typedef EditFeedData = ({
  String? title,
  List<String> hashtags,
  String note,
  String? imageLocalPath,
});

@freezed
class EditFeedState with _$EditFeedState {
  factory EditFeedState.idle({FeedFailure? failure}) = _IdleState;

  factory EditFeedState.loading(EditFeedData data) = _LoadingState;

  factory EditFeedState.editing(EditFeedData data, {FeedFailure? failure}) =
      _EditingState;

  factory EditFeedState.updated(FeedEntry updated) = _UpdatedState;
}

extension EditFeedStateX on EditFeedState {
  bool get isLoading => maybeWhen(loading: (_) => true, orElse: () => false);

  bool get isEditing =>
      maybeWhen(editing: (_, __) => true, orElse: () => false);

  bool get isUpdated => maybeWhen(updated: (_) => true, orElse: () => false);

  FeedFailure? get failure =>
      mapOrNull(idle: (e) => e.failure, editing: (e) => e.failure);

  FeedEntry? get updated => mapOrNull(updated: (e) => e.updated);

  EditFeedData get data => when(
    idle: (_) => (
      title: null,
      hashtags: const <String>[],
      note: '',
      imageLocalPath: null,
    ),
    loading: (data) => data,
    editing: (data, _) => data,
    updated: (updated) => (
      title: updated.title,
      hashtags: updated.hashtags,
      note: updated.note,
      imageLocalPath: updated.imageLocalPath,
    ),
  );
}
