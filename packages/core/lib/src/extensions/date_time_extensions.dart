import 'package:timeago/timeago.dart' as timeago;

bool _timeagoLocaleInitialized = false;

extension DateTimeX on DateTime {
  String get ago {
    return agoWithLocale('en');
  }

  String agoWithLocale(String localeCode) {
    _ensureTimeagoLocales();
    return timeago.format(toLocal(), locale: _supportedLocaleCode(localeCode));
  }
}

void _ensureTimeagoLocales() {
  if (_timeagoLocaleInitialized) return;
  timeago.setLocaleMessages('ko', timeago.KoMessages());
  timeago.setLocaleMessages('ja', timeago.JaMessages());
  _timeagoLocaleInitialized = true;
}

String _supportedLocaleCode(String localeCode) {
  switch (localeCode) {
    case 'ko':
      return 'ko';
    case 'ja':
      return 'ja';
    default:
      return 'en';
  }
}
