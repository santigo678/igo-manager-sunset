import 'package:flutter/material.dart';

class AppColors {
  // Nuevo esquema de colores: paleta Sunset
  static const bg        = Color(0xFF08131A);
  static const bg2       = Color(0xFF0C1F26);
  static const bg3       = Color(0xFF0F2A33);
  static const surface   = Color(0x14FFFFFF);
  static const surface2  = Color(0x24FFFFFF);
  static const border    = Color(0x20FFFFFF);
  static const border2   = Color(0x2EFFFFFF);

  static const sunset    = Color(0xFFFF6B6B);
  static const sunsetL   = Color(0xFFFF9A8A);

  static const violet    = Color(0xFF7C5CFF);
  static const violetL   = Color(0xFF9B86FF);

  static const mint      = Color(0xFF3EE0C9);
  static const mintL     = Color(0xFF7EF3DD);
  static const gray      = Color(0xFF7F8A90);
  static const grayL     = Color(0xFFB7BEC3);

  static const text      = Color(0xFFF8FAFC);
  static const text2     = Color(0xFF9FB3C2);
  static const text3     = Color(0xFF6F8592);

  // Aliases for backward compatibility with original palette names
  static const indigo    = violet;
  static const indigoL   = violetL;
  static const coral     = sunset;
  static const coralL    = sunsetL;
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      primary:   AppColors.sunset,
      secondary: AppColors.violet,
      surface:   AppColors.bg2,
      error:     AppColors.sunsetL,
    ),
    fontFamily: 'Sora',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg3,
      foregroundColor: AppColors.text,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Sora',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.sunset,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Sora',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      labelStyle: const TextStyle(color: AppColors.text2),
      hintStyle: const TextStyle(color: AppColors.text3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border2, width: 0.6),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border2, width: 0.6),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.violet, width: 1.2),
      ),
    ),
  );
}
