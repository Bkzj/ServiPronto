import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const blue = Color(0xFF1467B1);
  static const orange = Color(0xFFF57C22);
  static const _darkBlue = Color(0xFF8CCBFF);
  static const _darkOrange = Color(0xFFFFB778);

  static ThemeData get light => _theme(Brightness.light);
  static ThemeData get dark => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: isDark ? _darkBlue : blue,
          brightness: brightness,
        ).copyWith(
          primary: isDark ? _darkBlue : blue,
          secondary: isDark ? _darkOrange : orange,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF101925)
          : const Color(0xFFF4F7FB),
      focusColor: scheme.primary.withValues(alpha: 0.18),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(36),
        ),
        color: isDark ? const Color(0xFF182536) : Colors.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
    );
  }
}
