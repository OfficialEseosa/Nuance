import 'package:flutter/material.dart';
import 'package:nuance/core/theme/nuance_theme.dart';

class NuanceCard extends StatelessWidget {
  const NuanceCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.backgroundColor,
    this.gradientColors,
    this.darkGradientColors,
    this.borderColor,
    this.borderWidth = 2,
    this.radius = 20,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final List<Color>? darkGradientColors;
  final Color? borderColor;
  final double borderWidth;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isDark = NuancePalette.isDark(context);
    final bgColor = backgroundColor ?? Theme.of(context).colorScheme.surface;
    final outlineColor = borderColor ?? NuancePalette.borderColor(context);
    final effectiveGradient = isDark
        ? darkGradientColors ??
              (gradientColors != null
                  ? const [NuancePalette.darkCard, NuancePalette.darkSurface]
                  : null)
        : gradientColors;
    final effectiveBackground = isDark ? NuancePalette.darkCard : bgColor;

    return Container(
      decoration: BoxDecoration(
        color: effectiveGradient == null ? effectiveBackground : null,
        gradient: effectiveGradient != null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: effectiveGradient,
              )
            : null,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: outlineColor, width: borderWidth),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
