import 'package:flutter/material.dart';
import 'package:nuance/core/theme/nuance_theme.dart';

class NuanceGradientBackground extends StatelessWidget {
  const NuanceGradientBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
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
