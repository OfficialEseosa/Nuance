import 'package:flutter/material.dart';

class NuanceCard extends StatelessWidget {
  const NuanceCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 2,
    this.radius = 20,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final color = backgroundColor ?? Theme.of(context).colorScheme.surface;
    final outlineColor = borderColor ?? const Color(0xFFE5E7EB);

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: outlineColor, width: borderWidth),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1C000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
