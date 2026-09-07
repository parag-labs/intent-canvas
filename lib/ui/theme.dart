import 'package:flutter/material.dart';

/// The design tokens for IntentCanvas — a calm, dark, spatial home surface.
class AppTheme {
  static const bg = Color(0xFF0B0D14);
  static const surface = Color(0xFF141824);
  static const surface2 = Color(0xFF1B2130);
  static const border = Color(0x22FFFFFF);
  static const text = Color(0xFFE7EAF2);
  static const muted = Color(0xFF98A2B8);
  static const accent = Color(0xFF7C6CFF);
  static const accent2 = Color(0xFF34D9C8);

  static ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accent2,
        surface: surface,
      ),
    );
  }
}
