// common/themes/theme_utils.dart

import 'package:flutter/material.dart';

class ThemeUtils {
  // ============================================================================
  // LIGHT THEME COLORS
  // ============================================================================
  static const Color $primaryColorLight = Color(0xFF105100);
  static const Color $secondaryColorLight = Color(0xFFFFFFFF);
  static const Color $backgroundColorLight = Color.fromARGB(255, 243, 227, 237);
  static const Color $accentColorLight = Color(0xFFFFE9F4);
  static const Color $blacksLight = Color(0xFF000000);
  static const Color $boxShadowColorLight = Color(0xFF000000);
  static const Color $borderColor = Color(0xFFE5E5E5);
  static const Color $fixedTextColor = Color(0xFFFFFFFF);

  // ============================================================================
  // DARK THEME COLORS
  // ============================================================================
  static const Color $primaryColorDark = Color(
    0xFF105100,
  ); // Lighter green for dark mode
  static const Color $secondaryColorDark = Color(0xFF1E1E1E); // Dark surface
  static const Color $backgroundColorDark = Color(
    0xFF121212,
  ); // Darker background
  static const Color $accentColorDark = Color(0xFF3D2832); // Dark pink accent
  static const Color $blacksDark = Color(
    0xFFE5E5E5,
  ); // Light text for dark mode
  static const Color $boxShadowColorDark = Color(0xFF06CB00);
  static const Color $borderColorDark = Color(0xFF022C00);

  // ============================================================================
  // COMMON COLORS (same in both themes)
  // ============================================================================
  static const Color $error = Colors.red;
  static const Color $success = Colors.green;
  static const Color $info = Colors.orangeAccent;

  // ============================================================================
  // DYNAMIC COLOR GETTERS (context-aware)
  // ============================================================================
  static Color primaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? $primaryColorDark
        : $primaryColorLight;
  }

  static Color secondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? $secondaryColorDark
        : $secondaryColorLight;
  }

  static Color backgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? $backgroundColorDark
        : $backgroundColorLight;
  }

  static Color accentColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? $accentColorDark
        : $accentColorLight;
  }

  static Color blacks(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? $blacksDark
        : $blacksLight;
  }

  static Color boxShadowColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? $boxShadowColorDark
        : $boxShadowColorLight;
  }

  static Color borderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? $borderColorDark
        : $borderColor;
  }

  // ============================================================================
  // BACKWARD COMPATIBILITY (for components not yet migrated)
  // ============================================================================
  static const Color $primaryColor = $primaryColorLight;
  static const Color $secondaryColor = $secondaryColorLight;
  static const Color $backgroundColor = $backgroundColorLight;
  static const Color $accentColor = $accentColorLight;
  static const Color $blacks = $blacksLight;
}
