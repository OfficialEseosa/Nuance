import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nuance/core/data/mock_content.dart';
import 'package:nuance/core/models/nuance_models.dart';
import 'package:nuance/core/providers/game_progress_provider.dart';
import 'package:nuance/core/providers/user_provider.dart';
import 'package:nuance/core/theme/nuance_theme.dart';
import 'package:nuance/core/widgets/mascot_bubble.dart';
import 'package:nuance/core/widgets/nuance_card.dart';
import 'package:nuance/core/widgets/nuance_gradient_background.dart';
import 'package:nuance/core/widgets/section_title.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _getLevelTitle(int level) {
    switch (level) {
      case 1:
        return 'Novice';
      case 2:
        return 'Learner';
      case 3:
        return 'Contributor';
      case 4:
        return 'Analyst';
      case 5:
        return 'Expert';
      case 6:
        return 'Scholar';
      case 7:
        return 'Master';
      case 8:
        return 'Sage';
      case 9:
        return 'Luminary';
      case 10:
        return 'Visionary';
      default:
        return 'Visionary+';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<UserProvider>().user;
    final progress = context.watch<GameProgressProvider>();

    if (user == null || progress.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final levelTitle = _getLevelTitle(user.level);
    final badgeStates = kBadges
        .map(
          (badge) => BadgeProgress(
            name: badge.name,
            description: badge.description,
            unlocked: progress.unlockedBadges.contains(badge.name),
          ),
        )
        .toList(growable: false);
    final badgesCount = progress.badgesCount;
    final activeDays = progress.streakDays.clamp(0, 7);

    return NuanceGradientBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 110),
          children: [
            NuanceCard(
              borderColor: NuancePalette.cardPurpleBorder,
              gradientColors: [NuancePalette.cardPurpleBg, Color(0xFFEDE9FE)],
              darkGradientColors: const [
                NuancePalette.darkCard,
                NuancePalette.darkSurface,
              ],
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const MascotBubble(
                    size: 72,
                    icon: Icons.emoji_events_rounded,
                    iconColor: NuancePalette.warning,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.username,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: const LinearGradient(
                        colors: [
                          NuancePalette.primary,
                          NuancePalette.secondary,
                        ],
                      ),
                    ),
                    child: Text(
                      'Level ${user.level}: $levelTitle',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ProfileStat(
                        value: '${user.totalXp}',
                        label: 'Total XP',
                        color: NuancePalette.secondary,
                      ),
                      _ProfileStat(
                        value: '${user.streak}',
                        label: 'Day Streak',
                        color: NuancePalette.warning,
                      ),
                      _ProfileStat(
                        value: '$badgesCount',
                        label: 'Badges',
                        color: NuancePalette.success,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _PerformanceGrid(
              storiesCompared: progress.storiesCompared,
              biasFlags: progress.biasFlags,
              accuracy: progress.accuracyPercent,
              streakDays: progress.streakDays,
            ),
            const SizedBox(height: 18),
            NuanceCard(
              borderColor: NuancePalette.cardYellowBorder,
              gradientColors: [NuancePalette.cardYellowBg, Color(0xFFFEF3C7)],
              darkGradientColors: const [
                NuancePalette.darkCard,
                NuancePalette.darkSurface,
              ],
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                    title: 'Badge Collection',
                    subtitle: '$badgesCount of ${kBadges.length} earned',
                  ),
                  const SizedBox(height: 12),
                  ...badgeStates.map(
                    (badge) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _BadgeTile(badge: badge),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            NuanceCard(
              borderColor: NuancePalette.cardOrangeBorder,
              gradientColors: [NuancePalette.cardOrangeBg, Color(0xFFFEF8C3)],
              darkGradientColors: const [
                NuancePalette.darkCard,
                NuancePalette.darkSurface,
              ],
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Streak Tracker',
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keep learning daily to maintain your streak.',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _DayBubble(label: 'M', active: activeDays >= 1),
                      _DayBubble(label: 'T', active: activeDays >= 2),
                      _DayBubble(label: 'W', active: activeDays >= 3),
                      _DayBubble(label: 'T', active: activeDays >= 4),
                      _DayBubble(label: 'F', active: activeDays >= 5),
                      _DayBubble(label: 'S', active: activeDays >= 6),
                      _DayBubble(label: 'S', active: activeDays >= 7),
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

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _PerformanceGrid extends StatelessWidget {
  const _PerformanceGrid({
    required this.storiesCompared,
    required this.biasFlags,
    required this.accuracy,
    required this.streakDays,
  });

  final int storiesCompared;
  final int biasFlags;
  final int accuracy;
  final int streakDays;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: 'Performance Overview',
          subtitle: 'Your current media literacy momentum.',
        ),
        const SizedBox(height: 10),
        GridView(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 104,
          ),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _MetricCard(
              label: 'Stories Compared',
              value: '$storiesCompared',
              icon: Icons.compare_rounded,
              tint: const Color(0xFFDBEAFE),
            ),
            _MetricCard(
              label: 'Bias Flags',
              value: '$biasFlags',
              icon: Icons.flag_rounded,
              tint: const Color(0xFFFEE2E2),
            ),
            _MetricCard(
              label: 'Accuracy',
              value: '$accuracy%',
              icon: Icons.insights_rounded,
              tint: const Color(0xFFDCFCE7),
            ),
            _MetricCard(
              label: 'Streak',
              value: '$streakDays days',
              icon: Icons.local_fire_department_rounded,
              tint: const Color(0xFFFEF3C7),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = Theme.of(context).colorScheme.onSurface;

    return NuanceCard(
      padding: const EdgeInsets.all(14),
      backgroundColor: tint,
      borderColor: Colors.transparent,
      darkGradientColors: const [
        NuancePalette.darkCard,
        NuancePalette.darkSurface,
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: textColor),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              height: 1.2,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge});

  final BadgeProgress badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = Theme.of(context).colorScheme.onSurface;
    final tint = badge.unlocked
        ? NuancePalette.warning
        : const Color(0xFF9CA3AF);

    return NuanceCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: tint.withValues(alpha: 0.16),
            child: Icon(
              badge.unlocked ? Icons.emoji_events_rounded : Icons.lock_rounded,
              color: tint,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(badge.description, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          if (badge.unlocked)
            Text(
              'Unlocked',
              style: theme.textTheme.labelMedium?.copyWith(
                color: NuancePalette.warning,
              ),
            ),
        ],
      ),
    );
  }
}

class _DayBubble extends StatelessWidget {
  const _DayBubble({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final isDark = NuancePalette.isDark(context);
    final bg = active ? const Color(0xFFF59E0B) : const Color(0xFFE5E7EB);
    final fg = active
        ? (isDark ? const Color(0xFF102026) : Colors.white)
        : Theme.of(context).textTheme.bodySmall?.color ??
              NuancePalette.mutedInk;

    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(
            active
                ? Icons.local_fire_department_rounded
                : Icons.circle_outlined,
            size: 16,
            color: fg,
          ),
        ),
      ],
    );
  }
}
