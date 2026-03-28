import 'package:flutter/material.dart';
import 'package:nuance/core/data/mock_content.dart';
import 'package:nuance/core/theme/nuance_theme.dart';
import 'package:nuance/core/widgets/mascot_bubble.dart';
import 'package:nuance/core/widgets/nuance_card.dart';
import 'package:nuance/core/widgets/nuance_gradient_background.dart';
import 'package:nuance/core/widgets/section_title.dart';
import 'package:nuance/core/widgets/stat_pill.dart';
import 'package:nuance/features/path/presentation/widgets/mission_node.dart';

class PathScreen extends StatelessWidget {
  const PathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NuanceGradientBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 110),
          children: [
            // Header with Greeting
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning, Raphael! 👋',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Break the scroll. Build your perspective.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const MascotBubble(size: 56),
              ],
            ),
            const SizedBox(height: 24),
            
            // Stats Cards (with colored borders and gradients)
            Row(
              children: const [
                Expanded(
                  child: _TopStatCard(
                    label: 'Streak',
                    value: '7',
                    footnote: 'days',
                    icon: Icons.local_fire_department_rounded,
                    borderColor: NuancePalette.cardOrangeBorder,
                    gradientColors: [NuancePalette.cardOrangeBg, Color(0xFFFCD34D)],
                    textColor: NuancePalette.orangeText,
                    iconColor: Color(0xFFF59E0B),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _TopStatCard(
                    label: 'Level',
                    value: '6',
                    footnote: 'Analyst',
                    icon: Icons.star_rounded,
                    borderColor: NuancePalette.cardYellowBorder,
                    gradientColors: [NuancePalette.cardYellowBg, Color(0xFFFCD34D)],
                    textColor: NuancePalette.yellowText,
                    iconColor: Color(0xFFDCBA34),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // XP Progress Card
            NuanceCard(
              borderColor: NuancePalette.cardPurpleBorder,
              gradientColors: [NuancePalette.cardPurpleBg, Color(0xFFF3E8FF)],
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: NuancePalette.secondary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Level 6 Progress',
                        style: theme.textTheme.labelLarge?.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: 0.64,
                      minHeight: 12,
                      color: NuancePalette.secondary,
                      backgroundColor: const Color(0xFFE9D5FF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '64 / 100 XP (36 to next level)',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Trending Card
            NuanceCard(
              borderColor: NuancePalette.cardRedBorder,
              gradientColors: [NuancePalette.cardRedBg, Color(0xFFFEE2E2)],
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        color: NuancePalette.danger,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Trending Now',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: NuancePalette.redText,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Climate package passes after high-stakes vote',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: NuancePalette.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Compare 3 sources with opposite framing and earn +40 XP.',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: NuancePalette.danger,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(
                            color: NuancePalette.cardRedBorder,
                            width: 2,
                          ),
                        ),
                      ),
                      child: const Text('Compare Headlines'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            SectionTitle(
              title: 'Learning Path',
              subtitle: kDailyFocus,
              trailing: FilledButton.tonal(
                onPressed: () {},
                child: const Text('Today'),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                StatPill(
                  icon: Icons.stars_rounded,
                  label: 'This Week',
                  value: '420 XP',
                  tint: NuancePalette.warning,
                ),
                SizedBox(width: 8),
                StatPill(
                  icon: Icons.track_changes_rounded,
                  label: 'Accuracy',
                  value: '84%',
                  tint: NuancePalette.success,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(kCampaignMissions.length, (index) {
              final mission = kCampaignMissions[index];
              return MissionNode(mission: mission, alignLeft: index.isEven);
            }),
          ],
        ),
      ),
    );
  }
}

class _TopStatCard extends StatelessWidget {
  const _TopStatCard({
    required this.label,
    required this.value,
    required this.footnote,
    required this.icon,
    required this.borderColor,
    required this.gradientColors,
    required this.textColor,
    required this.iconColor,
  });

  final String label;
  final String value;
  final String footnote;
  final IconData icon;
  final Color borderColor;
  final List<Color> gradientColors;
  final Color textColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return NuanceCard(
      borderColor: borderColor,
      gradientColors: gradientColors,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                      color: textColor,
                    ),
                  ),
                  Text(
                    footnote,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Icon(icon, color: iconColor, size: 40),
            ],
          ),
        ],
      ),
    );
  }
}
