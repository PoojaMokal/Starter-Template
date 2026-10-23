extension StringExtensions on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  /// Shows only the last [visible] characters, e.g. `XXXXXX1234`.
  String mask({int visible = 4, String char = 'X'}) => length <= visible
      ? this
      : '${char * (length - visible)}${substring(length - visible)}';
}

extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
}
