import 'package:core/core.dart';

import 'feed_error.dart';

class FeedException extends AppException {
  final FeedError error;

  const FeedException._(
    this.error, {
    required super.message,
    required super.code,
    super.cause,
    super.stackTrace,
  });

  const FeedException.invalidEntry({Object? cause, StackTrace? stackTrace})
    : this._(
        FeedError.invalidEntry,
        message: FeedError.invalidEntryMessage,
        code: FeedError.invalidEntryCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const FeedException.entryNotFound({Object? cause, StackTrace? stackTrace})
    : this._(
        FeedError.entryNotFound,
        message: FeedError.entryNotFoundMessage,
        code: FeedError.entryNotFoundCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const FeedException.storageFailure({Object? cause, StackTrace? stackTrace})
    : this._(
        FeedError.storageFailure,
        message: FeedError.storageFailureMessage,
        code: FeedError.storageFailureCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const FeedException.unknown({Object? cause, StackTrace? stackTrace})
    : this._(
        FeedError.unknown,
        message: FeedError.unknownMessage,
        code: FeedError.unknownCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  factory FeedException.fromError(
    FeedError error, {
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return FeedException._(
      error,
      message: error.message,
      code: error.code,
      cause: cause,
      stackTrace: stackTrace,
    );
  }
}
