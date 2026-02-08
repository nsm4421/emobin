extension StringX on String {
  bool get isBlank => trim().isEmpty;
  bool get isNotBlank => !isBlank;

  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String truncate(int maxLength, {String suffix = '...'}) {
    if (maxLength <= 0) return '';
    if (length <= maxLength) return this;
    if (suffix.length >= maxLength) return substring(0, maxLength);
    return substring(0, maxLength - suffix.length) + suffix;
  }

  int? toIntOrNull() => int.tryParse(this);
  double? toDoubleOrNull() => double.tryParse(this);

  String? get nullIfBlank => isBlank ? null : this;
}

extension StringNullableX on String? {
  String? get nullIfBlank {
    final value = this;
    if (value == null) return null;
    return value.trim().isEmpty ? null : value;
  }
}
