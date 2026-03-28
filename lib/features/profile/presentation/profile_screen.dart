import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nuance/core/data/mock_content.dart';
import 'package:nuance/core/models/nuance_models.dart';
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
    final isDark = NuancePalette.isDark(context);
    final user = context.watch<UserProvider>().user;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final levelTitle = _getLevelTitle(user.level);

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
                        color: isDark ? const Color(0xFF102026) : Colors.white,
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
                        value: '${user.badges}',
                        label: 'Badges',
                        color: NuancePalette.success,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _PerformanceGrid(),
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
                    subtitle:
                        '${kBadges.where((b) => b.unlocked).length} of ${kBadges.length} earned',
                  ),
                  const SizedBox(height: 12),
                  ...kBadges.map(
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
                    children: const [
                      _DayBubble(label: 'M', active: true),
                      _DayBubble(label: 'T', active: true),
                      _DayBubble(label: 'W', active: true),
                      _DayBubble(label: 'T', active: true),
                      _DayBubble(label: 'F', active: true),
                      _DayBubble(label: 'S', active: true),
                      _DayBubble(label: 'S', active: false),
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
  const _PerformanceGrid();

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
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.6,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            _MetricCard(
              label: 'Stories Compared',
              value: '18',
              icon: Icons.compare_rounded,
              tint: Color(0xFFDBEAFE),
            ),
            _MetricCard(
              label: 'Bias Flags',
              value: '41',
              icon: Icons.flag_rounded,
              tint: Color(0xFFFEE2E2),
            ),
            _MetricCard(
              label: 'Accuracy',
              value: '84%',
              icon: Icons.insights_rounded,
              tint: Color(0xFFDCFCE7),
            ),
            _MetricCard(
              label: 'Streak',
              value: '7 days',
              icon: Icons.local_fire_department_rounded,
              tint: Color(0xFFFEF3C7),
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
      backgroundColor: tint,
      borderColor: Colors.transparent,
      darkGradientColors: const [
        NuancePalette.darkCard,
        NuancePalette.darkSurface,
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: theme.textTheme.bodySmall),
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
