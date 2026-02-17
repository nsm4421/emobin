part of 'feed_emotion_preset_cubit.dart';

@freezed
class FeedEmotionPresetState with _$FeedEmotionPresetState {
  const factory FeedEmotionPresetState.idle() = _IdleState;

  const factory FeedEmotionPresetState.loading(List<String> emotions) =
      _LoadingState;

  const factory FeedEmotionPresetState.fetched(
    List<String> emotions, {
    String? failure,
  }) = _FetchedState;
}

extension FeedEmotionPresetStateX on FeedEmotionPresetState {
  List<String> get emotions => maybeWhen(
    loading: (emotions) => emotions,
    fetched: (emotions, _) => emotions,
    orElse: () => const <String>[],
  );

  bool get isLoading => maybeWhen(loading: (_) => true, orElse: () => false);

  String? get failure =>
      maybeWhen(fetched: (_, failure) => failure, orElse: () => null);
}
