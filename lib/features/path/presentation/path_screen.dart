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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning, Raphael',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
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
                const MascotBubble(size: 52),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: const [
                Expanded(
                  child: _TopStatCard(
                    label: 'Streak',
                    value: '7',
                    footnote: 'days',
                    icon: Icons.local_fire_department_rounded,
                    top: Color(0xFFFBBF24),
                    bottom: Color(0xFFF59E0B),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _TopStatCard(
                    label: 'Level',
                    value: '6',
                    footnote: 'Analyst',
                    icon: Icons.star_rounded,
                    top: Color(0xFF60A5FA),
                    bottom: Color(0xFF7C3AED),
                  ),
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
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: NuancePalette.secondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Level 6 Progress',
                        style: theme.textTheme.labelLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
            const SizedBox(height: 12),
            NuanceCard(
              backgroundColor: const Color(0xFFFFF1F2),
              borderColor: const Color(0xFFFCA5A5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trending Now',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: NuancePalette.danger,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Climate package passes after high-stakes vote',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Compare 3 sources with opposite framing and earn +40 XP.',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  FilledButton.tonal(
                    onPressed: () {},
                    child: const Text('Compare Headlines'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionTitle(
              title: 'Learning Path',
              subtitle: kDailyFocus,
              trailing: FilledButton.tonal(
                onPressed: () {},
                child: const Text('Today'),
              ),
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
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
    required this.top,
    required this.bottom,
  });

  final String label;
  final String value;
  final String footnote;
  final IconData icon;
  final Color top;
  final Color bottom;

  @override
  Widget build(BuildContext context) {
    return NuanceCard(
      borderColor: Colors.transparent,
      padding: const EdgeInsets.all(14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              top.withValues(alpha: 0.15),
              bottom.withValues(alpha: 0.24),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 6),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      footnote,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(icon, color: bottom, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
