// common/themes/app_theme.dart

import 'package:flutter/material.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';

class AppTheme {
  // ============================================================================
  // LIGHT THEME
  // ============================================================================
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: ThemeUtils.$primaryColorLight,
      secondary: ThemeUtils.$accentColorLight,
      surface: ThemeUtils.$secondaryColorLight,
      error: ThemeUtils.$error,
      onPrimary: ThemeUtils.$secondaryColorLight,
      onSecondary: ThemeUtils.$primaryColorLight,
      onSurface: ThemeUtils.$blacksLight,
      onError: ThemeUtils.$secondaryColorLight,
    ),

    // Scaffold
    scaffoldBackgroundColor: ThemeUtils.$backgroundColorLight,

    // App Bar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: ThemeUtils.$primaryColorLight,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: ThemeUtils.$primaryColorLight),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: ThemeUtils.$primaryColorLight,
      ),
    ),

    // Cards
    cardTheme: CardThemeData(
      color: ThemeUtils.$secondaryColorLight,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    // Elevated Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeUtils.$primaryColorLight,
        foregroundColor: ThemeUtils.$secondaryColorLight,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),

    // Outlined Buttons
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ThemeUtils.$primaryColorLight,
        side: const BorderSide(color: ThemeUtils.$primaryColorLight, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),

    // Text Buttons
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ThemeUtils.$primaryColorLight,
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ThemeUtils.$accentColorLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: ThemeUtils.$primaryColorLight,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: ThemeUtils.$error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: ThemeUtils.$secondaryColorLight,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: ThemeUtils.$secondaryColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
    ),

    // Drawer Theme
    drawerTheme: const DrawerThemeData(
      backgroundColor: ThemeUtils.$secondaryColorLight,
      elevation: 4,
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: ThemeUtils.$primaryColorLight,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: ThemeUtils.$primaryColorLight,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: ThemeUtils.$primaryColorLight,
      ),
      headlineLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: ThemeUtils.$primaryColorLight,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: ThemeUtils.$blacksLight),
      bodyMedium: TextStyle(fontSize: 14, color: ThemeUtils.$blacksLight),
      bodySmall: TextStyle(fontSize: 12, color: ThemeUtils.$blacksLight),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: ThemeUtils.$primaryColorLight,
      size: 24,
    ),
  );

  // ============================================================================
  // DARK THEME
  // ============================================================================
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: ThemeUtils.$primaryColorDark,
      secondary: ThemeUtils.$accentColorDark,
      surface: ThemeUtils.$secondaryColorDark,
      error: ThemeUtils.$error,
      onPrimary: ThemeUtils.$blacksDark,
      onSecondary: ThemeUtils.$blacksDark,
      onSurface: ThemeUtils.$blacksDark,
      onError: ThemeUtils.$secondaryColorDark,
    ),

    // Scaffold
    scaffoldBackgroundColor: ThemeUtils.$backgroundColorDark,

    // App Bar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: ThemeUtils.$blacksDark,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: ThemeUtils.$blacksDark),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: ThemeUtils.$blacksDark,
      ),
    ),

    // Cards
    cardTheme: CardThemeData(
      color: ThemeUtils.$secondaryColorDark,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    // Elevated Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeUtils.$primaryColorDark,
        foregroundColor: ThemeUtils.$blacksDark,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),

    // Outlined Buttons
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ThemeUtils.$primaryColorDark,
        side: const BorderSide(color: ThemeUtils.$primaryColorDark, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),

    // Text Buttons
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ThemeUtils.$primaryColorDark,
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ThemeUtils.$accentColorDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: ThemeUtils.$primaryColorDark,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: ThemeUtils.$error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: ThemeUtils.$secondaryColorDark,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: ThemeUtils.$secondaryColorDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
    ),

    // Drawer Theme
    drawerTheme: const DrawerThemeData(
      backgroundColor: ThemeUtils.$secondaryColorDark,
      elevation: 4,
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: ThemeUtils.$blacksDark,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: ThemeUtils.$blacksDark,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: ThemeUtils.$blacksDark,
      ),
      headlineLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: ThemeUtils.$blacksDark,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: ThemeUtils.$blacksDark),
      bodyMedium: TextStyle(fontSize: 14, color: ThemeUtils.$blacksDark),
      bodySmall: TextStyle(fontSize: 12, color: ThemeUtils.$blacksDark),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: ThemeUtils.$blacksDark, size: 24),
  );
}
