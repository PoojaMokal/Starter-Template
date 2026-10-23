class RoleUtils {
  RoleUtils._();

  static const String maker = 'Maker';
  static const String checker = 'Checker';
  static const String dual = 'Dual';

  /// Maps a raw API role to its display name:
  /// `maker` → Maker, `checker` → Checker, `lcra` / `lcru` → Dual.
  /// Unknown values are returned unchanged.
  static String getDisplayRole(String? raw) {
    final value = raw?.trim() ?? '';
    return switch (value.toLowerCase()) {
      'maker' => maker,
      'checker' => checker,
      'lcra' || 'lcru' => dual,
      _ => value,
    };
  }
}
