import 'package:flutter/material.dart';
import 'package:nuance/core/theme/nuance_theme.dart';

class NuanceGradientBackground extends StatelessWidget {
  const NuanceGradientBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = NuancePalette.isDark(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [
                  NuancePalette.darkGradientTop,
                  NuancePalette.darkGradientMid,
                  NuancePalette.darkGradientBottom,
                ]
              : const [
                  NuancePalette.gradientBlue,
                  NuancePalette.gradientPurple,
                  NuancePalette.gradientPink,
                ],
        ),
      ),
      child: child,
    );
  }
}
