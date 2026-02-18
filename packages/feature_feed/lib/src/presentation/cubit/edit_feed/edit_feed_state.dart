part of 'edit_feed_cubit.dart';

typedef EditFeedData = ({String? emotion, int intensity, String note});

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
    idle: (_) => (emotion: null, intensity: 0, note: ''),
    loading: (data) => data,
    editing: (data, _) => data,
    updated: (updated) => (
      emotion: updated.emotion,
      intensity: updated.intensity,
      note: updated.note,
    ),
  );
}
