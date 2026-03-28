import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class NuancePalette {
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color secondary = Color(0xFF7C3AED);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color gradientBlue = Color(0xFFDBEAFE);
  static const Color gradientPurple = Color(0xFFE9D5FF);
  static const Color gradientPink = Color(0xFFFCE7F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC);
  static const Color ink = Color(0xFF111827);
  static const Color mutedInk = Color(0xFF6B7280);
  static const Color border = Color(0xFFD1D5DB);
}

ThemeData buildNuanceTheme() {
  final textBase = GoogleFonts.poppinsTextTheme();

  final textTheme = textBase.copyWith(
    headlineSmall: textBase.headlineSmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: NuancePalette.ink,
    ),
    titleLarge: textBase.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: NuancePalette.ink,
    ),
    titleMedium: textBase.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: NuancePalette.ink,
    ),
    bodyLarge: textBase.bodyLarge?.copyWith(
      color: NuancePalette.ink,
      height: 1.4,
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: textBase.bodyMedium?.copyWith(
      color: NuancePalette.mutedInk,
      height: 1.4,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: textBase.bodySmall?.copyWith(
      color: NuancePalette.mutedInk,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: textBase.labelLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: NuancePalette.ink,
    ),
    labelMedium: textBase.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: NuancePalette.mutedInk,
    ),
  );

  final scheme = ColorScheme.fromSeed(
    seedColor: NuancePalette.primary,
    primary: NuancePalette.primary,
    surface: NuancePalette.surface,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: NuancePalette.background,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: NuancePalette.ink,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: textTheme.titleLarge,
    ),
    cardTheme: CardThemeData(
      color: NuancePalette.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: NuancePalette.border, width: 2),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: NuancePalette.primary,
      linearTrackColor: Color(0xFFE5E7EB),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: NuancePalette.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: textTheme.labelLarge,
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: const BorderSide(color: NuancePalette.border),
      labelStyle: textTheme.labelMedium,
      selectedColor: NuancePalette.primary.withValues(alpha: 0.14),
      backgroundColor: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: NuancePalette.warning,
      foregroundColor: NuancePalette.ink,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
  );
}
