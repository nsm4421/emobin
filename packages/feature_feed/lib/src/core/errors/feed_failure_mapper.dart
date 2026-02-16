import 'feed_error.dart';
import 'feed_exception.dart';
import 'feed_failure.dart';

extension FeedFailureMapper on Object {
  FeedFailure toFeedFailure([StackTrace? stackTrace]) {
    if (this is FeedException) {
      final exception = this as FeedException;
      return FeedFailure.fromError(
        exception.error,
        cause: exception.cause ?? exception,
        stackTrace: exception.stackTrace ?? stackTrace,
      );
    }

    return FeedFailure.fromError(
      FeedError.unknown,
      cause: this,
      stackTrace: stackTrace,
    );
  }
}
