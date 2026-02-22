part of 'create_feed_cubit.dart';

typedef CreateFeedData = ({
  String? title,
  List<String> hashtags,
  String note,
  String? imageLocalPath,
});

@freezed
class CreateFeedState with _$CreateFeedState {
  factory CreateFeedState.loading(CreateFeedData data) = _LoadingState;

  factory CreateFeedState.editing(CreateFeedData data, {FeedFailure? failure}) =
      _EditingState;

  factory CreateFeedState.created({
    @Default(false) bool isDraft,
    required FeedEntry created,
  }) = _CreatedState;
}

extension CreateFeedStateX on CreateFeedState {
  bool get isLoading => maybeWhen(loading: (_) => true, orElse: () => false);

  bool get isEditing =>
      maybeWhen(editing: (_, __) => true, orElse: () => false);

  bool get isCreated =>
      maybeWhen(created: (_, __) => true, orElse: () => false);

  FeedFailure? get failure => mapOrNull(editing: (e) => e.failure);

  FeedEntry? get created => mapOrNull(created: (e) => e.created);

  CreateFeedData get data => when(
    loading: (data) => data,
    editing: (data, _) => data,
    created: (_, created) => (
      title: created.title,
      hashtags: created.hashtags,
      note: created.note,
      imageLocalPath: created.imageLocalPath,
    ),
  );
}
