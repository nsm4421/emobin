import 'package:timeago/timeago.dart' as timeago;

extension DateTimeX on DateTime {
  String get ago {
    final local = toLocal();
    final now = DateTime.now();

    final isSameDay =
        local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
    if (isSameDay) {
      final difference = now.difference(local);
      if (difference.isNegative || difference.inMinutes < 1) {
        return 'today';
      }
      return timeago.format(local, locale: 'en');
    }

    if (local.year == now.year) {
      return '${local.month}월 ${local.day}일';
    }

    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
