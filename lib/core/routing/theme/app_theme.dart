import 'package:flutter/material.dart';

class AppTheme {
  // Colors from the screenshots
  static const Color primaryColor = Color(0xFF6750A4); // Purple accent
  static const Color secondaryColor = Color(0xFF625B71);
  static const Color approveColor = Color(0xFF6750A4); // Approve button
  static const Color rejectColor = Color(0xFFBA1A1A); // Reject button (red)
  static const Color successColor = Color(0xFF107C10);
  static const Color warningColor = Color(0xFFE69500);
  static const Color backgroundColor = Color(0xFFFEF7FF);
  static const Color surfaceColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF1C1B1F);
  static const Color textSecondaryColor = Color(0xFF49454F);
  static const Color dividerColor = Color(0xFFE6E1E5);
  static const Color sessionCodeBgColor = Color(0xFFF3EDF7);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: rejectColor,
      surface: surfaceColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: textPrimaryColor,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      surfaceTintColor: Colors.transparent,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimaryColor),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: textPrimaryColor),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimaryColor),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimaryColor),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textPrimaryColor),
      bodyLarge: TextStyle(fontSize: 16, color: textPrimaryColor),
      bodyMedium: TextStyle(fontSize: 14, color: textSecondaryColor),
      bodySmall: TextStyle(fontSize: 12, color: textSecondaryColor),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      filled: true,
      fillColor: surfaceColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: surfaceColor,
      surfaceTintColor: Colors.transparent,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: sessionCodeBgColor,
      labelStyle: const TextStyle(fontSize: 14, color: primaryColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}