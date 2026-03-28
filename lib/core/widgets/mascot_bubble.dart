import 'package:flutter/material.dart';
import 'package:nuance/core/theme/nuance_theme.dart';

class MascotBubble extends StatelessWidget {
  const MascotBubble({
    this.icon = Icons.psychology_rounded,
    this.iconColor = NuancePalette.secondary,
    this.size = 54,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Icon(icon, color: iconColor, size: size * 0.5),
      ),
    );
  }
}
