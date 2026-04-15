import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color bg            = Color(0xFF0E0E10);
  static const Color surface       = Color(0xFF1A1A1E);
  static const Color card          = Color(0xFF222228);
  static const Color border        = Color(0xFF2E2E36);

  static const Color primary       = Color(0xFFFF5A1F);
  static const Color primaryDim    = Color(0x26FF5A1F);
  static const Color secondary     = Color(0xFFFFBE2E);
  static const Color secondaryDim  = Color(0x26FFBE2E);
  static const Color accent        = Color(0xFF6C63FF);
  static const Color accentDim     = Color(0x266C63FF);

  static const Color success       = Color(0xFF2ECC8A);
  static const Color successDim    = Color(0x262ECC8A);
  static const Color danger        = Color(0xFFFF4B6E);
  static const Color dangerDim     = Color(0x26FF4B6E);

  static const Color textPrimary   = Color(0xFFF2F2F5);
  static const Color textSecondary = Color(0xFF8888A0);
  static const Color textMuted     = Color(0xFF44445A);

  static const Map<String, Color> categoryColors = {
    'Burgers':      Color(0xFFFF5A1F),
    'Pizza':        Color(0xFFFF8C42),
    'Sushi':        Color(0xFF2ECC8A),
    'Chinese':      Color(0xFFFFBE2E),
    'Indian':       Color(0xFFFF4B6E),
    'Desserts':     Color(0xFFBE6EFF),
    'Healthy':      Color(0xFF2ECC8A),
    'Coffee':       Color(0xFFBF8B5E),
    'Packages':     Color(0xFF5B8DEF),
  };

  static Color statusColor(String status) {
    switch (status) {
      case 'Placed':     return secondary;
      case 'Preparing':  return primary;
      case 'On the Way': return success;
      case 'Delivered':  return success;
      case 'Cancelled':  return danger;
      default:           return textSecondary;
    }
  }

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: surface,
      error: danger,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    cardTheme: CardThemeData(
       color: card,
       elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: border),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      hintStyle: const TextStyle(color: textMuted, fontSize: 14),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    dividerColor: border,
  );
}
