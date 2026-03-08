import 'package:flutter/material.dart';

/// Material 3 Theme for DrinkLion
class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFFF39C12); // Warm orange
  static const Color secondaryColor = Color(0xFF27AE60); // Green
  static const Color accentColor = Color(0xFF3498DB); // Blue
  static const Color errorColor = Color(0xFFE74C3C); // Red

  // Light theme colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF8F9FA);
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);

  // Success/Warning/Info colors
  static const Color successColor = Color(0xFF27AE60);
  static const Color warningColor = Color(0xFFF39C12);
  static const Color infoColor = Color(0xFF3498DB);

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: errorColor,
        surface: lightSurface,
      ),
      textTheme: _buildTextTheme(ThemeData.light().textTheme, isLight: true),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: lightBackground,
        foregroundColor: lightTextPrimary,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size.fromHeight(48),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size.fromHeight(48),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: lightTextSecondary, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: lightBackground,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: errorColor,
        surface: darkSurface,
      ),
      textTheme: _buildTextTheme(ThemeData.dark().textTheme, isLight: false),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: darkBackground,
        foregroundColor: darkTextPrimary,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size.fromHeight(48),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: darkSurface,
      ),
    );
  }

  static TextTheme _buildTextTheme(
    TextTheme baseTheme, {
    required bool isLight,
  }) {
    final color = isLight ? lightTextPrimary : darkTextPrimary;
    final secondaryColor = isLight ? lightTextSecondary : darkTextSecondary;

    return baseTheme.copyWith(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.4,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.4,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
