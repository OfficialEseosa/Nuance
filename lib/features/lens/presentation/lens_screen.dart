import 'package:flutter/material.dart';
import 'package:nuance/core/audio/sound_service.dart';
import 'package:nuance/core/data/mock_content.dart';
import 'package:nuance/core/models/nuance_models.dart';
import 'package:nuance/core/providers/user_provider.dart';
import 'package:nuance/core/theme/nuance_theme.dart';
import 'package:nuance/core/widgets/mascot_bubble.dart';
import 'package:nuance/core/widgets/nuance_card.dart';
import 'package:nuance/core/widgets/nuance_gradient_background.dart';
import 'package:nuance/core/widgets/section_title.dart';
import 'package:provider/provider.dart';

class LensScreen extends StatefulWidget {
  const LensScreen({required this.onOpenStoryCompare, super.key});

  final VoidCallback onOpenStoryCompare;

  @override
  State<LensScreen> createState() => _LensScreenState();
}

class _LensScreenState extends State<LensScreen> {
  static const List<String> _categories = [
    'All',
    'Politics',
    'Climate',
    'Global',
  ];

  int _selectedCategoryIndex = 0;
  final Set<String> _comparedSources = <String>{};

  String get _selectedCategory => _categories[_selectedCategoryIndex];

  List<StoryPerspective> get _visibleStories {
    switch (_selectedCategory) {
      case 'Politics':
        return kStoryPerspectives
            .where(
              (story) =>
                  story.headline.toLowerCase().contains('senate') ||
                  story.headline.toLowerCase().contains('package'),
            )
            .toList();
      case 'Climate':
        return kStoryPerspectives
            .where((story) => story.headline.toLowerCase().contains('climate'))
            .toList();
      case 'Global':
        return kStoryPerspectives
            .where(
              (story) =>
                  story.source.toLowerCase().contains('national') ||
                  story.source.toLowerCase().contains('frontier'),
            )
            .toList();
      case 'All':
      default:
        return kStoryPerspectives;
    }
  }

  void _selectCategory(int index) {
    if (_selectedCategoryIndex == index) return;
    SoundService.instance.playTap();
    setState(() => _selectedCategoryIndex = index);
  }

  Future<void> _openStoryCompare(StoryPerspective story) async {
    widget.onOpenStoryCompare();

    if (_comparedSources.contains(story.source)) return;

    _comparedSources.add(story.source);
    await context.read<UserProvider>().addXP(5);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compared ${story.source}. +5 XP'),
        duration: const Duration(milliseconds: 1400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = NuancePalette.isDark(context);

    return NuanceGradientBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 110),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'News Feed',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'See all sides of the same story',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const MascotBubble(
                  size: 56,
                  icon: Icons.psychology_rounded,
                  iconColor: NuancePalette.primary,
                ),
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_categories.length, (index) {
                  final label = _categories[index];
                  final tint = switch (label) {
                    'All' => NuancePalette.primary,
                    'Politics' => const Color(0xFF2563EB),
                    'Climate' => const Color(0xFF22C55E),
                    'Global' => const Color(0xFF7C3AED),
                    _ => NuancePalette.primary,
                  };

                  return Padding(
                    padding: EdgeInsets.only(right: index == 3 ? 0 : 10),
                    child: _CategoryChip(
                      label: label,
                      tint: tint,
                      isActive: _selectedCategoryIndex == index,
                      onTap: () => _selectCategory(index),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 18),
            ...List.generate(_visibleStories.length, (index) {
              final story = _visibleStories[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _PerspectiveCard(
                  perspective: story,
                  onTap: () => _openStoryCompare(story),
                ),
              );
            }),
            if (_visibleStories.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: NuanceCard(
                  child: Text(
                    'No stories found for $_selectedCategory right now.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            NuanceCard(
              borderColor: NuancePalette.cardPurpleBorder,
              gradientColors: [NuancePalette.cardPurpleBg, Color(0xFFF3E8FF)],
              darkGradientColors: const [
                NuancePalette.darkCard,
                NuancePalette.darkSurface,
              ],
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                    title: 'Frame Radar',
                    subtitle: 'How outlets currently shape this story.',
                    trailing: FilledButton.tonal(
                      onPressed: () {
                        SoundService.instance.playTap();
                        widget.onOpenStoryCompare();
                      },
                      child: const Text('Deep Dive'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...kFrameSignals.map(
                    (signal) => _FrameSignalBar(signal, isDark: isDark),
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

class _PerspectiveCard extends StatelessWidget {
  const _PerspectiveCard({required this.perspective, required this.onTap});

  final StoryPerspective perspective;
  final VoidCallback onTap;

  Color get _leaningColor {
    final leaning = perspective.leaning.toLowerCase();
    if (leaning.contains('left')) {
      return const Color(0xFF2D86D8);
    }
    if (leaning.contains('right')) {
      return const Color(0xFFE15D52);
    }
    return NuancePalette.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: NuanceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _leaningColor.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    perspective.leaning,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: _leaningColor,
                    ),
                  ),
                ),
                const Spacer(),
                if (perspective.credibilityScore > 84)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF97316), Color(0xFFEF4444)],
                      ),
                    ),
                    child: Text(
                      'Trending',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(perspective.source, style: theme.textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(perspective.headline, style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            Text(perspective.framingNote, style: theme.textTheme.bodySmall),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '3 sources',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF60A5FA),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 3),
                Container(
                  width: 10,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9CA3AF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 3),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF87171),
                    shape: BoxShape.circle,
                  ),
                ),
                const Spacer(),
                Text(
                  'Compare ->',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: NuancePalette.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FrameSignalBar extends StatelessWidget {
  const _FrameSignalBar(this.signal, {required this.isDark});

  final FrameSignal signal;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final percent = (signal.value * 100).round();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  signal.label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '$percent%',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: NuancePalette.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: signal.value,
              minHeight: 10,
              color: NuancePalette.secondary,
              backgroundColor: isDark
                  ? NuancePalette.darkSecondary
                  : const Color(0xFFE9D5FF),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.tint,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final Color tint;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = NuancePalette.isDark(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            color: isActive
                ? tint.withValues(alpha: isDark ? 0.28 : 0.18)
                : isDark
                ? NuancePalette.darkSecondary
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive
                  ? tint
                  : isDark
                  ? NuancePalette.darkStroke
                  : tint.withValues(alpha: 0.48),
              width: 2,
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isActive ? tint : (isDark ? NuancePalette.darkText : tint),
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
