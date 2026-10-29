import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryDark = Color(0xFF4338CA);
  static const Color primaryLight = Color(0xFFEEF2FF);

  static const Color secondary = Color(0xFF14B8A6);
  static const Color accent = Color(0xFFF59E0B);

  static const Color correct = Color(0xFF22C55E);
  static const Color wrong = Color(0xFFEF4444);
  static const Color locked = Color(0xFF9CA3AF);

  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Colors.white;

  static const Color bgDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF334155);

  static const Color textDark = Color(0xFF0F172A);
  static const Color textLight = Color(0xFFF8FAFC);
  static const Color textMuted = Color(0xFF64748B);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceLight,
        error: AppColors.wrong,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.bgLight,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.textDark),
        displayMedium: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.textDark),
        displaySmall: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppColors.textDark),
        headlineLarge: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppColors.textDark),
        headlineMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textDark),
        headlineSmall: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textDark),
        titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textDark),
        titleMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textDark),
        titleSmall: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: AppColors.textDark),
        bodyLarge: GoogleFonts.inter(color: AppColors.textDark),
        bodyMedium: GoogleFonts.inter(color: AppColors.textDark),
        bodySmall: GoogleFonts.inter(color: AppColors.textMuted),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: const Color(0xFF6366F1),
        secondary: AppColors.secondary,
        surface: AppColors.surfaceDark,
        error: AppColors.wrong,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.bgDark,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.textLight),
        displayMedium: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.textLight),
        displaySmall: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppColors.textLight),
        headlineLarge: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppColors.textLight),
        headlineMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textLight),
        headlineSmall: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textLight),
        titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textLight),
        titleMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textLight),
        titleSmall: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: AppColors.textLight),
        bodyLarge: GoogleFonts.inter(color: AppColors.textLight),
        bodyMedium: GoogleFonts.inter(color: AppColors.textLight),
        bodySmall: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF334155)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}
