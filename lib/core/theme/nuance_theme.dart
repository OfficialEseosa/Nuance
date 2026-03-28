import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class NuancePalette {
  // Light mode colors
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color secondary = Color(0xFF7C3AED);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color accentBlue = Color(0xFF3B82F6);
  // Web design pastel gradient colors
  static const Color gradientBlue = Color(0xFFDBEAFE);
  static const Color gradientPurple = Color(0xFFF3E8FF);
  static const Color gradientPink = Color(0xFFFCE7F3);
  // Card accent colors
  static const Color cardOrangeBorder = Color(0xFFFEDCBA);
  static const Color cardOrangeBg = Color(0xFFFEF3C7);
  static const Color cardYellowBorder = Color(0xFFFEE08B);
  static const Color cardYellowBg = Color(0xFFFEF08A);
  static const Color cardPurpleBorder = Color(0xFFD8B4FE);
  static const Color cardPurpleBg = Color(0xFFF3E8FF);
  static const Color cardRedBorder = Color(0xFFFCA5A5);
  static const Color cardRedBg = Color(0xFFFEE2E2);
  static const Color cardBlueBorder = Color(0xFFBFDBFE);
  static const Color cardBlueBg = Color(0xFFEFF6FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC);
  static const Color ink = Color(0xFF111827);
  static const Color mutedInk = Color(0xFF6B7280);
  static const Color border = Color(0xFFD1D5DB);
  // Text colors for cards
  static const Color orangeText = Color(0xFF92400E);
  static const Color yellowText = Color(0xFF854D0E);
  static const Color redText = Color(0xFFDC2626);
  static const Color purpleText = Color(0xFF6D28D9);
  static const Color blueText = Color(0xFF1E40AF);

  // Dark mode colors (Duolingo-inspired)
  static const Color darkBg = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSecondary = Color(0xFF3F3F3F);
  static const Color darkTertiary = Color(0xFF58C4DC); // Duolingo cyan
  static const Color darkAccent = Color(0xFF58C4DC);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkMutedText = Color(0xFFBBBBBB);
}

ThemeData buildNuanceTheme() {
  final textBase = GoogleFonts.poppinsTextTheme();

  final textTheme = textBase.copyWith(
    headlineSmall: textBase.headlineSmall?.copyWith(
      fontWeight: FontWeight.w800,
      color: NuancePalette.ink,
      fontSize: 28,
    ),
    titleLarge: textBase.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: NuancePalette.ink,
      fontSize: 18,
    ),
    titleMedium: textBase.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: NuancePalette.ink,
      fontSize: 16,
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
      fontSize: 13,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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

ThemeData buildNuanceDarkTheme() {
  final textBase = GoogleFonts.poppinsTextTheme();

  final textTheme = textBase.copyWith(
    headlineSmall: textBase.headlineSmall?.copyWith(
      fontWeight: FontWeight.w800,
      color: NuancePalette.darkText,
      fontSize: 28,
    ),
    titleLarge: textBase.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: NuancePalette.darkText,
      fontSize: 18,
    ),
    titleMedium: textBase.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: NuancePalette.darkText,
      fontSize: 16,
    ),
    bodyLarge: textBase.bodyLarge?.copyWith(
      color: NuancePalette.darkText,
      height: 1.4,
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: textBase.bodyMedium?.copyWith(
      color: NuancePalette.darkMutedText,
      height: 1.4,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: textBase.bodySmall?.copyWith(
      color: NuancePalette.darkMutedText,
      fontWeight: FontWeight.w500,
      fontSize: 13,
    ),
    labelLarge: textBase.labelLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: NuancePalette.darkText,
    ),
    labelMedium: textBase.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: NuancePalette.darkMutedText,
    ),
  );

  final scheme = ColorScheme.fromSeed(
    seedColor: NuancePalette.darkTertiary,
    primary: NuancePalette.darkTertiary,
    surface: NuancePalette.darkSurface,
    brightness: Brightness.dark,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: NuancePalette.darkBg,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: NuancePalette.darkSurface,
      foregroundColor: NuancePalette.darkText,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: textTheme.titleLarge,
    ),
    cardTheme: CardThemeData(
      color: NuancePalette.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: NuancePalette.darkSecondary, width: 2),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: NuancePalette.darkTertiary,
      linearTrackColor: Color(0xFF3F3F3F),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: NuancePalette.darkTertiary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide(color: NuancePalette.darkSecondary),
      labelStyle: textTheme.labelMedium,
      selectedColor: NuancePalette.darkTertiary.withValues(alpha: 0.3),
      backgroundColor: NuancePalette.darkSecondary,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: NuancePalette.darkTertiary,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
  );
}
