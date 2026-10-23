import 'package:flutter/material.dart';

import '../../utils/role_utils.dart';

class RoleColors {
  RoleColors._();

  static const Color maker = Color(0xFF2563EB);
  static const Color checker = Color(0xFF7C3AED);
  static const Color dual = Color(0xFF0D9488);
  static const Color unknown = Color(0xFF64748B);

  /// Colour for a raw role string from the API (e.g. `maker`, `lcra`).
  static Color forRole(String? raw) => switch (RoleUtils.getDisplayRole(raw)) {
    RoleUtils.maker => maker,
    RoleUtils.checker => checker,
    RoleUtils.dual => dual,
    _ => unknown,
  };
}
