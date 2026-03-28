import 'package:flutter/material.dart';

class NuanceCard extends StatelessWidget {
  const NuanceCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.backgroundColor,
    this.gradientColors,
    this.borderColor,
    this.borderWidth = 2,
    this.radius = 20,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final Color? borderColor;
  final double borderWidth;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Theme.of(context).colorScheme.surface;
    final outlineColor = borderColor ?? const Color(0xFFE5E7EB);

    return Container(
      decoration: BoxDecoration(
        color: gradientColors == null ? bgColor : null,
        gradient: gradientColors != null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors!,
              )
            : null,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: outlineColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: const Color(0x19000000),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
