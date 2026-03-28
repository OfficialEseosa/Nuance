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
  static const Color gradientPurple = Color(0xFFF3E8FF);
  static const Color gradientPink = Color(0xFFFCE7F3);

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

  static const Color orangeText = Color(0xFF92400E);
  static const Color yellowText = Color(0xFF854D0E);
  static const Color redText = Color(0xFFDC2626);
  static const Color purpleText = Color(0xFF6D28D9);
  static const Color blueText = Color(0xFF1E40AF);

  // Duolingo-inspired dark palette
  static const Color darkBg = Color(0xFF131F24);
  static const Color darkSurface = Color(0xFF1F2D35);
  static const Color darkCard = Color(0xFF243642);
  static const Color darkSecondary = Color(0xFF364A56);
  static const Color darkStroke = Color(0xFF4B5E69);
  static const Color darkPrimary = Color(0xFF58CC02);
  static const Color darkAccent = Color(0xFF1CB0F6);
  static const Color darkText = Color(0xFFF7FBFC);
  static const Color darkMutedText = Color(0xFFB4C2C9);
  static const Color darkGradientTop = Color(0xFF0F1A20);
  static const Color darkGradientMid = Color(0xFF14252E);
  static const Color darkGradientBottom = Color(0xFF1B2F3A);

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color textColor(BuildContext context) {
    return isDark(context) ? darkText : ink;
  }

  static Color mutedTextColor(BuildContext context) {
    return isDark(context) ? darkMutedText : mutedInk;
  }

  static Color borderColor(BuildContext context) {
    return isDark(context) ? darkStroke : border;
  }
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

  final scheme =
      ColorScheme.fromSeed(
        seedColor: NuancePalette.darkPrimary,
        primary: NuancePalette.darkPrimary,
        secondary: NuancePalette.darkAccent,
        surface: NuancePalette.darkSurface,
        brightness: Brightness.dark,
      ).copyWith(
        onPrimary: const Color(0xFF0F1A20),
        onSurface: NuancePalette.darkText,
        onSecondary: const Color(0xFF0F1A20),
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: NuancePalette.darkBg,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: NuancePalette.darkText,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: textTheme.titleLarge,
    ),
    cardTheme: CardThemeData(
      color: NuancePalette.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: NuancePalette.darkStroke, width: 2),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: NuancePalette.darkAccent,
      linearTrackColor: NuancePalette.darkSecondary,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: NuancePalette.darkPrimary,
        foregroundColor: const Color(0xFF0F1A20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: const BorderSide(color: NuancePalette.darkStroke),
      labelStyle: textTheme.labelMedium,
      selectedColor: NuancePalette.darkAccent.withValues(alpha: 0.35),
      backgroundColor: NuancePalette.darkSecondary,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: NuancePalette.darkPrimary,
      foregroundColor: const Color(0xFF0F1A20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
  );
}
