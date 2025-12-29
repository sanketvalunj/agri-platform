import 'package:flutter/material.dart';

class AppTheme {
  // 🌞 Light Mode Colors
  static const Color lightBackground = Color(0xFFF4FAF6); // Soft light green
  static const Color lightCard = Colors.white;
  static const Color lightPrimaryText = Color(0xFF1F2937); // Dark charcoal
  static const Color lightSecondaryText = Color(0xFF6B7280); // Muted gray
  static const Color lightPrimaryGreen = Color(0xFF2E7D32); // Natural green

  // 🌙 Dark Mode Colors
  static const Color darkBackground =
      Color(0xFF0F1F17); // Deep forest green (previous bottom nav color)
  static const Color darkCard = Color(0xFF162D22); // Slightly lighter green
  static const Color darkPrimaryText = Color(0xFFE6F2EA); // Soft off-white
  static const Color darkSecondaryText = Color(0xFFA7C7B7); // Muted green-gray
  static const Color darkAccentGreen =
      Color(0xFF4CAF50); // Soft mint/emerald green

  // Legacy colors for backward compatibility
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color mutedGreen = Color(0xFF388E3C);
  static const Color accentTeal = Color(0xFF00695C);
  static const Color warmAccent = Color(0xFFFFB74D);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: lightPrimaryGreen,
        brightness: Brightness.light,
        primary: lightPrimaryGreen,
        onPrimary: Colors.white,
        surface: lightCard,
        onSurface: lightPrimaryText,
        background: lightBackground,
        onBackground: lightPrimaryText,
      ),
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightPrimaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimaryGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: lightPrimaryText,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: lightPrimaryText,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: lightPrimaryText,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: lightPrimaryText,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: lightPrimaryText,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: lightSecondaryText,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightCard,
        selectedItemColor: lightPrimaryGreen,
        unselectedItemColor: lightSecondaryText,
        selectedIconTheme: IconThemeData(color: lightPrimaryGreen),
        unselectedIconTheme: IconThemeData(color: lightSecondaryText),
        elevation: 8,
      ),
      iconTheme: const IconThemeData(color: lightPrimaryGreen),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: lightPrimaryText,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: darkAccentGreen,
        brightness: Brightness.dark,
        primary: darkAccentGreen,
        onPrimary: Colors.white,
        surface: darkCard,
        onSurface: darkPrimaryText,
        background: darkBackground,
        onBackground: darkPrimaryText,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkCard,
        foregroundColor: darkPrimaryText,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: darkPrimaryText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkAccentGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkPrimaryText,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkPrimaryText,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: darkPrimaryText,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: darkPrimaryText,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: darkPrimaryText,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: darkSecondaryText,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkBackground, // Same as scaffold background
        selectedItemColor: darkAccentGreen, // Bright green
        unselectedItemColor: darkSecondaryText, // Muted grey-green
        selectedIconTheme: IconThemeData(color: darkAccentGreen),
        unselectedIconTheme: IconThemeData(color: darkSecondaryText),
        elevation: 8,
      ),
      iconTheme: const IconThemeData(color: darkAccentGreen),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: darkCard,
        contentTextStyle: TextStyle(color: darkPrimaryText),
      ),
    );
  }
}
