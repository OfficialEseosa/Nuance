import 'package:flutter/material.dart';
import 'package:nuance/core/models/nuance_models.dart';
import 'package:nuance/core/theme/nuance_theme.dart';

class MissionNode extends StatelessWidget {
  const MissionNode({
    required this.mission,
    required this.alignLeft,
    super.key,
  });

  final LessonMission mission;
  final bool alignLeft;

  Color get _statusColor {
    switch (mission.status) {
      case MissionStatus.completed:
        return NuancePalette.success;
      case MissionStatus.active:
        return NuancePalette.primary;
      case MissionStatus.locked:
        return const Color(0xFF9CA3AF);
    }
  }

  IconData get _statusIcon {
    switch (mission.status) {
      case MissionStatus.completed:
        return Icons.check_rounded;
      case MissionStatus.active:
        return Icons.play_arrow_rounded;
      case MissionStatus.locked:
        return Icons.lock_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final isDark = NuancePalette.isDark(context);
    final textColor = mission.status == MissionStatus.locked
        ? NuancePalette.mutedTextColor(context)
        : onSurface;
    final activeOutline = switch (mission.status) {
      MissionStatus.completed => NuancePalette.success.withValues(alpha: 0.55),
      MissionStatus.active => NuancePalette.primary.withValues(alpha: 0.55),
      MissionStatus.locked => const Color(0xFFD1D5DB),
    };

    return Align(
      alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 310),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? NuancePalette.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: activeOutline, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _statusColor,
              ),
              child: Icon(_statusIcon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mission.summary,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _TinyBadge(text: '+${mission.xpReward} XP'),
                      const SizedBox(width: 8),
                      _TinyBadge(text: '${mission.minutes} min'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: NuancePalette.isDark(context)
            ? NuancePalette.darkSecondary
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: NuancePalette.borderColor(context)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
