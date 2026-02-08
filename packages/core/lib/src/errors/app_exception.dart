import 'package:flutter/foundation.dart';

@immutable
class AppException implements Exception {
  final String message;
  final String? code;
  final Object? cause;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.cause,
    this.stackTrace,
  });

  @override
  String toString() {
    final codePart = code == null ? '' : ' ($code)';
    return 'AppException$codePart: $message';
  }
}
