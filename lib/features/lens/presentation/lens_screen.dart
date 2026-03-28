import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nuance/core/audio/sound_service.dart';
import 'package:nuance/core/models/news_cluster.dart';
import 'package:nuance/core/models/news_story.dart';
import 'package:nuance/core/providers/game_progress_provider.dart';
import 'package:nuance/core/providers/news_provider.dart';
import 'package:nuance/core/providers/user_provider.dart';
import 'package:nuance/core/theme/nuance_theme.dart';
import 'package:nuance/core/widgets/mascot_bubble.dart';
import 'package:nuance/core/widgets/nuance_card.dart';
import 'package:nuance/core/widgets/nuance_gradient_background.dart';
import 'package:nuance/core/widgets/section_title.dart';
import 'package:provider/provider.dart';

class LensScreen extends StatefulWidget {
  const LensScreen({required this.onOpenStoryCompare, super.key});

  final void Function({NewsStory? story, NewsCluster? cluster})
  onOpenStoryCompare;

  @override
  State<LensScreen> createState() => _LensScreenState();
}

class _LensScreenState extends State<LensScreen> {
  static const List<String> _categories = [
    'All',
    'World',
    'Politics',
    'Climate',
    'Business',
    'Tech',
  ];

  int _selectedCategoryIndex = 0;
  final Random _random = Random();

  String get _selectedCategory => _categories[_selectedCategoryIndex];

  List<NewsCluster> _filteredClusters(List<NewsCluster> clusters) {
    final byCategory = _selectedCategory == 'All'
        ? clusters
        : clusters
              .where((cluster) => cluster.category == _selectedCategory)
              .toList(growable: false);
    return byCategory
        .where((cluster) => cluster.stories.length >= 2)
        .toList(growable: false);
  }

  Future<void> _refreshNews() async {
    SoundService.instance.playTap();
    await context.read<NewsProvider>().refreshStories();
  }

  void _selectCategory(int index) {
    if (_selectedCategoryIndex == index) return;
    SoundService.instance.playTap();
    setState(() => _selectedCategoryIndex = index);
  }

  Future<void> _openClusterCompare(NewsCluster cluster) async {
    final progress = context.read<GameProgressProvider>();
    final user = context.read<UserProvider>();
    final result = await progress.recordStoryComparison(
      storyId: cluster.id,
      xpReward: 12,
    );

    if (result.xpAwarded > 0) {
      await user.addXP(result.xpAwarded);
    }
    await user.syncProgress(
      streak: progress.streakDays,
      completedLessons: progress.completedLessons,
      badges: progress.badgesCount,
    );

    if (!mounted) return;
    if (result.xpAwarded > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Compared ${cluster.sources.length} sources. +${result.xpAwarded} XP',
          ),
          duration: const Duration(milliseconds: 1400),
        ),
      );
      if (result.newlyUnlockedBadges.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Badge unlocked: ${result.newlyUnlockedBadges.join(', ')}',
            ),
            duration: const Duration(milliseconds: 1600),
          ),
        );
      }
    }

    widget.onOpenStoryCompare(story: cluster.primaryStory, cluster: cluster);
  }

  void _openRandomCluster(List<NewsCluster> clusters) {
    if (clusters.isEmpty) return;
    SoundService.instance.playTap();
    final picked = clusters[_random.nextInt(clusters.length)];
    _openClusterCompare(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = NuancePalette.isDark(context);
    final news = context.watch<NewsProvider>();
    final clusters = _filteredClusters(news.clusters);
    final radarStories = clusters.isEmpty
        ? news.stories
        : clusters.expand((cluster) => cluster.stories).toList(growable: false);
    final signals = _buildSignals(radarStories);

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
                        news.error == null
                            ? 'Compare the same event across multiple outlets'
                            : news.error!,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: news.isLoading ? null : _refreshNews,
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: news.isLoading
                        ? NuancePalette.mutedInk
                        : NuancePalette.darkAccent,
                  ),
                ),
                const MascotBubble(
                  size: 56,
                  icon: Icons.psychology_rounded,
                  iconColor: NuancePalette.primary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${clusters.length} compare-ready stories',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: NuancePalette.mutedTextColor(context),
                    ),
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: clusters.isEmpty
                      ? null
                      : () => _openRandomCluster(clusters),
                  icon: const Icon(Icons.casino_rounded, size: 16),
                  label: const Text('Surprise Me'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_categories.length, (index) {
                  final label = _categories[index];
                  final tint = switch (label) {
                    'All' => NuancePalette.primary,
                    'World' => const Color(0xFF60A5FA),
                    'Politics' => const Color(0xFF2563EB),
                    'Climate' => const Color(0xFF22C55E),
                    'Business' => const Color(0xFFF59E0B),
                    'Tech' => const Color(0xFF7C3AED),
                    _ => NuancePalette.primary,
                  };
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == _categories.length - 1 ? 0 : 10,
                    ),
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
            if (news.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
            ...clusters.map(
              (cluster) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ClusterCard(
                  cluster: cluster,
                  onTap: () => _openClusterCompare(cluster),
                ),
              ),
            ),
            if (!news.isLoading && clusters.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: NuanceCard(
                  child: Text(
                    'No multi-source clusters found for $_selectedCategory right now.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            NuanceCard(
              borderColor: NuancePalette.cardPurpleBorder,
              gradientColors: const [
                NuancePalette.cardPurpleBg,
                Color(0xFFF3E8FF),
              ],
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
                    subtitle: 'Signals generated from live clusters.',
                    trailing: FilledButton.tonal(
                      onPressed: clusters.isEmpty
                          ? null
                          : () => _openClusterCompare(clusters.first),
                      child: const Text('Deep Dive'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...signals.map(
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

  List<_SignalMetric> _buildSignals(List<NewsStory> stories) {
    if (stories.isEmpty) {
      return const [
        _SignalMetric(label: 'Emotion-Led Language', value: 0.0),
        _SignalMetric(label: 'Source Diversity', value: 0.0),
        _SignalMetric(label: 'Policy Detail Depth', value: 0.0),
        _SignalMetric(label: 'Claim Verification Cues', value: 0.0),
      ];
    }

    final sensationalWords = ['shocking', 'outrage', 'slam', 'crisis', 'chaos'];
    var emotionalCount = 0;
    var detailCount = 0;
    var verificationCueCount = 0;
    final sources = <String>{};

    for (final story in stories) {
      final text = '${story.title} ${story.summary}'.toLowerCase();
      if (sensationalWords.any(text.contains)) {
        emotionalCount += 1;
      }
      if (text.contains('according to') ||
          text.contains('report') ||
          text.contains('data') ||
          text.contains('analysis')) {
        detailCount += 1;
      }
      if (text.contains('officials said') ||
          text.contains('documents') ||
          text.contains('investigation') ||
          text.contains('evidence')) {
        verificationCueCount += 1;
      }
      sources.add(story.source);
    }

    final total = stories.length;
    final maxDiversity = 6;
    return [
      _SignalMetric(
        label: 'Emotion-Led Language',
        value: emotionalCount / total,
      ),
      _SignalMetric(
        label: 'Source Diversity',
        value: (sources.length / maxDiversity).clamp(0, 1).toDouble(),
      ),
      _SignalMetric(label: 'Policy Detail Depth', value: detailCount / total),
      _SignalMetric(
        label: 'Claim Verification Cues',
        value: verificationCueCount / total,
      ),
    ];
  }
}

class _ClusterCard extends StatelessWidget {
  const _ClusterCard({required this.cluster, required this.onTap});

  final NewsCluster cluster;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sources = cluster.stories.map((s) => s.source).take(3).toList();
    final moreCount = cluster.sources.length - sources.length;

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
                    color: NuancePalette.primary.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    cluster.category,
                    style: theme.textTheme.labelSmall,
                  ),
                ),
                const SizedBox(width: 8),
                if (cluster.isSynthesized)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: NuancePalette.warning.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Auto-Matched',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: NuancePalette.warning,
                      ),
                    ),
                  ),
                const Spacer(),
                Text(
                  '${cluster.sources.length} sources',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: NuancePalette.mutedTextColor(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              cluster.topicTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final source in sources)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: NuancePalette.darkSecondary.withValues(
                        alpha: 0.35,
                      ),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: NuancePalette.borderColor(context),
                      ),
                    ),
                    child: Text(source, style: theme.textTheme.labelSmall),
                  ),
                if (moreCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: NuancePalette.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '+$moreCount more',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: NuancePalette.secondary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Compare framing and take challenge',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 8),
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

class _SignalMetric {
  const _SignalMetric({required this.label, required this.value});

  final String label;
  final double value;
}

class _FrameSignalBar extends StatelessWidget {
  const _FrameSignalBar(this.signal, {required this.isDark});

  final _SignalMetric signal;
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
