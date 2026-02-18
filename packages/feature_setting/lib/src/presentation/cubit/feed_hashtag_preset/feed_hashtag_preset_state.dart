part of 'feed_hashtag_preset_cubit.dart';

@freezed
class FeedHashtagPresetState with _$FeedHashtagPresetState {
  const factory FeedHashtagPresetState.idle() = _IdleState;

  const factory FeedHashtagPresetState.loading(List<String> hashtags) =
      _LoadingState;

  const factory FeedHashtagPresetState.fetched(
    List<String> hashtags, {
    String? failure,
  }) = _FetchedState;
}

extension FeedHashtagPresetStateX on FeedHashtagPresetState {
  List<String> get hashtags => maybeWhen(
    loading: (hashtags) => hashtags,
    fetched: (hashtags, _) => hashtags,
    orElse: () => const <String>[],
  );

  bool get isLoading => maybeWhen(loading: (_) => true, orElse: () => false);

  String? get failure =>
      maybeWhen(fetched: (_, failure) => failure, orElse: () => null);
}
