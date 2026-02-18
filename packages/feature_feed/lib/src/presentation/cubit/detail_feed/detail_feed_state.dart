part of 'detail_feed_cubit.dart';

@freezed
class DetailFeedState with _$DetailFeedState {
  const factory DetailFeedState.loading() = _LoadingState;

  const factory DetailFeedState.loaded(FeedEntry entry) = _LoadedState;

  const factory DetailFeedState.notFound() = _NotFoundState;

  const factory DetailFeedState.failure(FeedFailure failure) = _FailureState;
}

extension DetailFeedStateX on DetailFeedState {
  bool get isLoading => maybeWhen(loading: () => true, orElse: () => false);

  bool get isLoaded => maybeWhen(loaded: (_) => true, orElse: () => false);

  bool get isNotFound => maybeWhen(notFound: () => true, orElse: () => false);

  bool get isFailure => maybeWhen(failure: (_) => true, orElse: () => false);

  FeedEntry? get entry => mapOrNull(loaded: (state) => state.entry);

  FeedFailure? get failure => mapOrNull(failure: (state) => state.failure);
}
