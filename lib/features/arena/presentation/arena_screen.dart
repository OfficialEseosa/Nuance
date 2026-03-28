import 'package:flutter/material.dart';
import 'package:nuance/core/data/mock_content.dart';
import 'package:nuance/core/models/nuance_models.dart';
import 'package:nuance/core/theme/nuance_theme.dart';
import 'package:nuance/core/widgets/mascot_bubble.dart';
import 'package:nuance/core/widgets/nuance_card.dart';
import 'package:nuance/core/widgets/nuance_gradient_background.dart';
import 'package:nuance/core/widgets/section_title.dart';

class ArenaScreen extends StatelessWidget {
  const ArenaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completion = 2 / kChallengeModules.length;

    return NuanceGradientBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Learn',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Master bias detection through interactive lessons',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const MascotBubble(
                  size: 52,
                  icon: Icons.lightbulb_rounded,
                  iconColor: NuancePalette.warning,
                ),
              ],
            ),
            const SizedBox(height: 12),
            NuanceCard(
              borderColor: const Color(0xFFD8B4FE),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Overall Progress',
                        style: theme.textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: NuancePalette.warning.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '2/${kChallengeModules.length}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: NuancePalette.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: completion,
                      minHeight: 11,
                      color: NuancePalette.secondary,
                      backgroundColor: const Color(0xFFE9D5FF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(completion * 100).round()}% complete',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SectionTitle(
              title: 'Practice Modules',
              subtitle: 'Pick a mode and stack XP.',
              trailing: Text(
                '${kChallengeModules.length} available',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: NuancePalette.primaryDark,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...List.generate(kChallengeModules.length, (index) {
              final module = kChallengeModules[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ChallengeCard(
                  module: module,
                  index: index + 1,
                  completed: index == 0,
                  locked: index == 2,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.module,
    required this.index,
    required this.completed,
    required this.locked,
  });

  final ChallengeModule module;
  final int index;
  final bool completed;
  final bool locked;

  Color get _difficultyColor {
    switch (module.difficulty) {
      case 'Fast':
        return NuancePalette.primary;
      case 'Medium':
        return NuancePalette.warning;
      case 'Hard':
        return NuancePalette.danger;
      default:
        return NuancePalette.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NuanceCard(
      borderColor: completed
          ? NuancePalette.success.withValues(alpha: 0.6)
          : locked
          ? const Color(0xFFD1D5DB)
          : _difficultyColor.withValues(alpha: 0.45),
      backgroundColor: completed ? const Color(0xFFECFDF5) : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: completed
                        ? [const Color(0xFF22C55E), const Color(0xFF16A34A)]
                        : locked
                        ? [const Color(0xFF9CA3AF), const Color(0xFF6B7280)]
                        : [NuancePalette.primary, NuancePalette.secondary],
                  ),
                ),
                child: completed
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 18,
                      )
                    : locked
                    ? const Icon(
                        Icons.lock_rounded,
                        color: Colors.white,
                        size: 18,
                      )
                    : Text(
                        '$index',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              Text(module.title, style: theme.textTheme.titleMedium),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _difficultyColor.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  module.difficulty,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: _difficultyColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            module.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: locked ? NuancePalette.mutedInk : NuancePalette.ink,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.timer_outlined, color: NuancePalette.mutedInk),
              const SizedBox(width: 4),
              Text(module.duration, style: theme.textTheme.bodySmall),
              const SizedBox(width: 12),
              Icon(Icons.stars_rounded, color: NuancePalette.secondary),
              const SizedBox(width: 4),
              Text('+${module.xpReward} XP', style: theme.textTheme.bodySmall),
              const Spacer(),
              FilledButton.tonal(
                onPressed: locked ? null : () {},
                child: Text(
                  locked
                      ? 'Locked'
                      : completed
                      ? 'Replay'
                      : 'Play',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
