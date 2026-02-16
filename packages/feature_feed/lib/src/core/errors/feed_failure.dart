import 'package:core/core.dart';

import 'feed_error.dart';

class FeedFailure extends Failure {
  final FeedError error;

  const FeedFailure._(
    this.error, {
    required String message,
    required String code,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         code: code,
         cause: cause,
         stackTrace: stackTrace,
       );

  const FeedFailure.invalidEntry({Object? cause, StackTrace? stackTrace})
    : this._(
        FeedError.invalidEntry,
        message: FeedError.invalidEntryMessage,
        code: FeedError.invalidEntryCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const FeedFailure.entryNotFound({Object? cause, StackTrace? stackTrace})
    : this._(
        FeedError.entryNotFound,
        message: FeedError.entryNotFoundMessage,
        code: FeedError.entryNotFoundCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const FeedFailure.storageFailure({Object? cause, StackTrace? stackTrace})
    : this._(
        FeedError.storageFailure,
        message: FeedError.storageFailureMessage,
        code: FeedError.storageFailureCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  const FeedFailure.unknown({Object? cause, StackTrace? stackTrace})
    : this._(
        FeedError.unknown,
        message: FeedError.unknownMessage,
        code: FeedError.unknownCode,
        cause: cause,
        stackTrace: stackTrace,
      );

  factory FeedFailure.fromError(
    FeedError error, {
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return FeedFailure._(
      error,
      message: error.message,
      code: error.code,
      cause: cause,
      stackTrace: stackTrace,
    );
  }
}
