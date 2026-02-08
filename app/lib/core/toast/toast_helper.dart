import 'package:flutter/material.dart';

part 'toast_overlay.dart';

final GlobalKey<NavigatorState> toastNavigatorKey = GlobalKey<NavigatorState>();

class ToastHelper {
  const ToastHelper._();

  static success(String message) {
    _show(message, type: _ToastType.success);
  }

  static error(String message) {
    _show(message, type: _ToastType.error);
  }

  static warning(String message) {
    _show(message, type: _ToastType.warning);
  }

  static void _show(String message, {_ToastType type = _ToastType.error}) {
    final overlay = toastNavigatorKey.currentState?.overlay;
    if (overlay == null) return;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        return _ToastOverlay(
          message: message,
          type: type,
          onComplete: entry.remove,
        );
      },
    );

    overlay.insert(entry);
  }
}
