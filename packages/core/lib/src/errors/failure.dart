import 'package:flutter/foundation.dart';

@immutable
class Failure {
  final String message;
  final String? code;
  final Object? cause;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.code,
    this.cause,
    this.stackTrace,
  });

  @override
  String toString() {
    final codePart = code == null ? '' : ' ($code)';
    return 'Failure$codePart: $message';
  }
}
