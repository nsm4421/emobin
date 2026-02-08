import 'package:flutter/foundation.dart';

enum LogLevel {
  debug('DEBUG'),
  info('INFO'),
  warn('WARN'),
  error('ERROR');

  const LogLevel(this.label);
  final String label;
}

enum LogMode { dev, prod }

@immutable
class AppLogger {
  const AppLogger._();

  static LogMode mode = kReleaseMode ? LogMode.prod : LogMode.dev;

  static void setMode(LogMode next) {
    mode = next;
  }

  static void log(
    String message, {
    LogLevel level = LogLevel.debug,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (mode == LogMode.prod && level == LogLevel.debug) return;

    debugPrint(_format(message, level: level));

    if (error != null) {
      debugPrint('  error: $error');
    }
    if (stackTrace != null) {
      debugPrint('  stack: $stackTrace');
    }
  }

  static String _format(
    String message, {
    required LogLevel level,
  }) {
    return '[${level.label}] $message';
  }
}
