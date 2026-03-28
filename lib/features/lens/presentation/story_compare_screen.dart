import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuance/core/audio/sound_service.dart';
import 'package:nuance/core/models/news_cluster.dart';
import 'package:nuance/core/models/news_story.dart';
import 'package:nuance/core/providers/game_progress_provider.dart';
import 'package:nuance/core/providers/news_provider.dart';
import 'package:nuance/core/providers/user_provider.dart';
import 'package:nuance/core/theme/nuance_theme.dart';
import 'package:nuance/core/widgets/nuance_card.dart';
import 'package:nuance/core/widgets/nuance_gradient_background.dart';
import 'package:provider/provider.dart';

class StoryCompareScreen extends StatefulWidget {
  const StoryCompareScreen({this.story, this.cluster, super.key});

  final NewsStory? story;
  final NewsCluster? cluster;

  @override
  State<StoryCompareScreen> createState() => _StoryCompareScreenState();
}

class _StoryCompareScreenState extends State<StoryCompareScreen> {
  int? _selectedAnswerIndex;
  bool _submitted = false;
  bool _wasCorrect = false;
  int _lastXpEarned = 0;
  bool _visitTracked = false;
  int _challengeSeed = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_visitTracked) return;
    _visitTracked = true;
    _trackVisit();
  }

  Future<void> _trackVisit() async {
    final news = context.read<NewsProvider>();
    final story = widget.story ?? news.topStory;
    final cluster =
        widget.cluster ?? (story != null ? news.clusterForStory(story) : null);
    if (cluster == null) return;

    final progress = context.read<GameProgressProvider>();
    final user = context.read<UserProvider>();
    final result = await progress.recordStoryComparison(
      storyId: cluster.id,
      xpReward: 8,
    );

    if (result.xpAwarded > 0) {
      await user.addXP(result.xpAwarded);
    }
    await user.syncProgress(
      streak: progress.streakDays,
      completedLessons: progress.completedLessons,
      badges: progress.badgesCount,
    );

    if (!mounted || result.xpAwarded <= 0) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('New event compared. +${result.xpAwarded} XP'),
        duration: const Duration(milliseconds: 1300),
      ),
    );
  }

  void _selectAnswer(int index) {
    if (_submitted) return;
    SoundService.instance.playTap();
    setState(() => _selectedAnswerIndex = index);
  }

  Future<void> _submitAnswer(
    NewsCluster cluster,
    _DynamicChallenge challenge,
  ) async {
    if (_selectedAnswerIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pick an answer before submitting.'),
          duration: Duration(milliseconds: 1400),
        ),
      );
      return;
    }

    final isCorrect = _selectedAnswerIndex == challenge.correctIndex;
    setState(() {
      _submitted = true;
      _wasCorrect = isCorrect;
    });

    final progress = context.read<GameProgressProvider>();
    final user = context.read<UserProvider>();
    final result = await progress.submitStoryChallenge(
      challengeId: 'story_compare_${cluster.id}_${challenge.challengeId}',
      correct: isCorrect,
      xpReward: challenge.xpReward,
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
    setState(() => _lastXpEarned = result.xpAwarded);
    if (isCorrect) {
      SoundService.instance.playSuccess();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.xpAwarded > 0
                ? 'Correct. +${result.xpAwarded} XP'
                : 'Correct.',
          ),
          duration: const Duration(milliseconds: 1400),
        ),
      );
    } else {
      SoundService.instance.playPop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not quite. Try again.'),
          duration: Duration(milliseconds: 1400),
        ),
      );
    }
  }

  void _shuffleChallenge() {
    SoundService.instance.playTap();
    setState(() {
      _challengeSeed += 1;
      _selectedAnswerIndex = null;
      _submitted = false;
      _wasCorrect = false;
      _lastXpEarned = 0;
    });
  }

  Future<void> _copyLink(String url) async {
    SoundService.instance.playTap();
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Story link copied to clipboard'),
        duration: Duration(milliseconds: 1200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = NuancePalette.isDark(context);
    final newsProvider = context.watch<NewsProvider>();
    final baseStory = widget.story ?? newsProvider.topStory;
    final cluster =
        widget.cluster ??
        (baseStory != null ? newsProvider.clusterForStory(baseStory) : null) ??
        newsProvider.topCluster;

    if (cluster == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Story Comparison')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final challenge = _buildChallenge(cluster, _challengeSeed);
    final leftLeaning = cluster.stories
        .where((story) => story.leaning.toLowerCase().contains('left'))
        .length;
    final rightLeaning = cluster.stories
        .where((story) => story.leaning.toLowerCase().contains('right'))
        .length;
    final centerLeaning = cluster.stories.length - leftLeaning - rightLeaning;

    return Scaffold(
      appBar: AppBar(title: const Text('Story Comparison')),
      body: NuanceGradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
          children: [
            NuanceCard(
              borderColor: const Color(0xFFBFDBFE),
              backgroundColor: const Color(0xFFEFF6FF),
              darkGradientColors: const [
                NuancePalette.darkCard,
                NuancePalette.darkSurface,
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shared Event',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: NuancePalette.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(cluster.topicTitle, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Comparing ${cluster.stories.length} takes from ${cluster.sources.length} sources.',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '${cluster.category} - Updated ${_timeAgo(cluster.latestPublishedAt)}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: NuancePalette.primaryDark,
                        ),
                      ),
                      const Spacer(),
                      FilledButton.tonal(
                        onPressed: () => _copyLink(cluster.primaryStory.url),
                        child: const Text('Copy Main Link'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            NuanceCard(
              darkGradientColors: const [
                NuancePalette.darkCard,
                NuancePalette.darkSurface,
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bias Spectrum', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _SpectrumBox(
                        label: 'L',
                        count: leftLeaning,
                        color: const Color(0xFF2563EB),
                      ),
                      const SizedBox(width: 6),
                      _SpectrumBox(
                        label: 'C',
                        count: centerLeaning,
                        color: const Color(0xFF9CA3AF),
                      ),
                      const SizedBox(width: 6),
                      _SpectrumBox(
                        label: 'R',
                        count: rightLeaning,
                        color: const Color(0xFFEF4444),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Source Angles',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            ...cluster.stories.map(
              (story) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _SourceAngleCard(story: story),
              ),
            ),
            const SizedBox(height: 4),
            NuanceCard(
              borderColor: const Color(0xFFD8B4FE),
              darkGradientColors: const [
                NuancePalette.darkCard,
                NuancePalette.darkSurface,
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Nuance Challenge',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      FilledButton.tonal(
                        onPressed: _shuffleChallenge,
                        child: const Text('Shuffle'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(challenge.prompt, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 12),
                  ...List.generate(challenge.options.length, (index) {
                    return _AnswerOption(
                      label: String.fromCharCode(65 + index),
                      answerText: challenge.options[index],
                      isDark: isDark,
                      isSelected: _selectedAnswerIndex == index,
                      isSubmitted: _submitted,
                      isCorrect: challenge.correctIndex == index,
                      onTap: () => _selectAnswer(index),
                    );
                  }),
                  if (_submitted) ...[
                    const SizedBox(height: 2),
                    Text(
                      _wasCorrect
                          ? challenge.successText
                          : challenge.failureText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _wasCorrect
                            ? NuancePalette.success
                            : NuancePalette.warning,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (_lastXpEarned > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '+$_lastXpEarned XP',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: NuancePalette.success,
                          ),
                        ),
                      ),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _submitAnswer(cluster, challenge),
                      child: Text(
                        _submitted ? 'Submit Again' : 'Submit Challenge',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _CoveragePanel(
                    title: 'What To Check',
                    points: [
                      'Who is quoted and who is missing?',
                      'Are claims backed by data or named sources?',
                      'What concrete context is omitted?',
                    ],
                    tone: const Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _CoveragePanel(
                    title: 'Nuance Moves',
                    points: [
                      'Compare wording intensity between outlets',
                      'Cross-check timeline and baseline numbers',
                      'Rewrite each angle in neutral language',
                    ],
                    tone: const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _DynamicChallenge _buildChallenge(NewsCluster cluster, int seed) {
    final key = (cluster.id.hashCode + seed).abs();
    final type = key % 4;
    final xpReward = 18 + (cluster.sources.length * 2).clamp(0, 8);

    switch (type) {
      case 0:
        return _neutralHeadlineChallenge(cluster, xpReward);
      case 1:
        return _credibilityChallenge(cluster, xpReward);
      case 2:
        return _missingContextChallenge(cluster, xpReward);
      default:
        return _framingFocusChallenge(cluster, xpReward);
    }
  }

  _DynamicChallenge _neutralHeadlineChallenge(NewsCluster cluster, int xp) {
    final options = cluster.stories
        .take(3)
        .map((s) => s.title)
        .toList(growable: false);
    if (options.length < 3) {
      options.addAll([
        'Officials release new policy details with timeline and cost estimates',
      ]);
    }

    var bestIndex = 0;
    var bestScore = 999;
    for (var i = 0; i < options.length; i++) {
      final score = _sensationalScore(options[i]);
      if (score < bestScore) {
        bestScore = score;
        bestIndex = i;
      }
    }

    return _DynamicChallenge(
      challengeId: 'neutral_headline',
      prompt: 'Which headline is the most neutral in tone?',
      options: options,
      correctIndex: bestIndex,
      successText: 'Correct. Neutral wording reduces framing bias.',
      failureText:
          'Look for fewer emotional trigger words and stronger specificity.',
      xpReward: xp,
    );
  }

  _DynamicChallenge _credibilityChallenge(NewsCluster cluster, int xp) {
    final picks = cluster.stories.take(3).toList(growable: false);
    final options = picks.map((s) => s.source).toList(growable: false);
    var bestIndex = 0;
    var bestScore = -1;
    for (var i = 0; i < picks.length; i++) {
      if (picks[i].credibilityScore > bestScore) {
        bestScore = picks[i].credibilityScore;
        bestIndex = i;
      }
    }

    return _DynamicChallenge(
      challengeId: 'credibility_pick',
      prompt:
          'Which outlet in this cluster currently has the highest credibility score?',
      options: options,
      correctIndex: bestIndex,
      successText: 'Nice. Credibility checks reduce misinformation risk.',
      failureText:
          'Try comparing source track records and evidence transparency.',
      xpReward: xp,
    );
  }

  _DynamicChallenge _missingContextChallenge(NewsCluster cluster, int xp) {
    final (options, correctIndex) = switch (cluster.category) {
      'Climate' => (
        [
          'Long-term emissions targets and cost timeline',
          'Only social-media reactions from politicians',
          'Speculation without cited data',
        ],
        0,
      ),
      'Politics' => (
        [
          'Voting breakdown, timeline, and legal process details',
          'Who had the most dramatic sound bite',
          'Rumors from unnamed online accounts',
        ],
        0,
      ),
      'Business' => (
        [
          'Quarterly numbers, baseline comparisons, and affected sectors',
          'Celebrity opinions on the company',
          'A single out-of-context quote',
        ],
        0,
      ),
      'Tech' => (
        [
          'Methodology, benchmark context, and deployment limits',
          'Only optimistic marketing claims',
          'Anonymous forum posts',
        ],
        0,
      ),
      _ => (
        [
          'Timeline, verified sources, and measurable impact',
          'Unverified screenshot threads',
          'Emotion-heavy commentary only',
        ],
        0,
      ),
    };

    return _DynamicChallenge(
      challengeId: 'missing_context',
      prompt: 'Which missing context would improve this event coverage most?',
      options: options,
      correctIndex: correctIndex,
      successText:
          'Correct. Context is what turns headlines into understanding.',
      failureText:
          'Choose the option that adds verifiable and structural context.',
      xpReward: xp,
    );
  }

  _DynamicChallenge _framingFocusChallenge(NewsCluster cluster, int xp) {
    final picks = cluster.stories.take(3).toList(growable: false);
    final options = picks.map((s) => s.source).toList(growable: false);
    var strongestIndex = 0;
    var strongestScore = -1;

    for (var i = 0; i < picks.length; i++) {
      final text = '${picks[i].title} ${picks[i].summary}'.toLowerCase();
      final score = [
        'cost',
        'economic',
        'burden',
        'regulation',
        'tax',
        'market',
      ].where(text.contains).length;
      if (score > strongestScore) {
        strongestScore = score;
        strongestIndex = i;
      }
    }

    return _DynamicChallenge(
      challengeId: 'framing_focus',
      prompt: 'Which source emphasizes economic-impact framing the most?',
      options: options,
      correctIndex: strongestIndex,
      successText: 'Great read. You identified the dominant framing axis.',
      failureText:
          'Scan for repeated cues like cost, burden, and market impacts.',
      xpReward: xp,
    );
  }

  int _sensationalScore(String text) {
    final lower = text.toLowerCase();
    final triggers = [
      'shocking',
      'outrage',
      'slam',
      'crisis',
      'chaos',
      'devastating',
      'blasts',
      'furious',
      'stunning',
      'panic',
    ];

    var score = 0;
    for (final word in triggers) {
      if (lower.contains(word)) {
        score += 2;
      }
    }
    if (text.contains('!')) score += 1;
    if (text.length < 45) score += 1;
    return score;
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().toUtc().difference(date.toUtc());
    if (diff.inMinutes < 60) return '${max(1, diff.inMinutes)}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _SourceAngleCard extends StatelessWidget {
  const _SourceAngleCard({required this.story});

  final NewsStory story;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final toneColor = _toneColor(story.leaning);

    return NuanceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(story.source, style: theme.textTheme.labelLarge),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: toneColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  story.leaning,
                  style: theme.textTheme.labelSmall?.copyWith(color: toneColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            story.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(story.summary, style: theme.textTheme.bodySmall, maxLines: 3),
          const SizedBox(height: 6),
          Text(
            'Credibility ${story.credibilityScore}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: NuancePalette.mutedTextColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Color _toneColor(String leaning) {
    final normalized = leaning.toLowerCase();
    if (normalized.contains('left')) return const Color(0xFF2563EB);
    if (normalized.contains('right')) return const Color(0xFFEF4444);
    return const Color(0xFF9CA3AF);
  }
}

class _CoveragePanel extends StatelessWidget {
  const _CoveragePanel({
    required this.title,
    required this.points,
    required this.tone,
  });

  final String title;
  final List<String> points;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return NuanceCard(
      darkGradientColors: const [
        NuancePalette.darkCard,
        NuancePalette.darkSurface,
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: tone,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: tone,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      point,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.label,
    required this.answerText,
    required this.isDark,
    required this.isSelected,
    required this.isSubmitted,
    required this.isCorrect,
    required this.onTap,
  });

  final String label;
  final String answerText;
  final bool isDark;
  final bool isSelected;
  final bool isSubmitted;
  final bool isCorrect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final baseBg = isDark
        ? NuancePalette.darkSecondary
        : const Color(0xFFF3F4F6);
    var bgColor = baseBg;
    var borderColor = isDark
        ? NuancePalette.darkStroke
        : const Color(0xFFD1D5DB);

    if (isSubmitted && isCorrect) {
      bgColor = NuancePalette.success.withValues(alpha: 0.18);
      borderColor = NuancePalette.success;
    } else if (isSubmitted && isSelected && !isCorrect) {
      bgColor = NuancePalette.danger.withValues(alpha: 0.15);
      borderColor = NuancePalette.danger;
    } else if (isSelected) {
      bgColor = NuancePalette.primary.withValues(alpha: 0.16);
      borderColor = NuancePalette.primary;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: NuancePalette.primary.withValues(alpha: 0.14),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: NuancePalette.primaryDark,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  answerText,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              if (isSubmitted && isCorrect)
                const Icon(
                  Icons.check_circle_rounded,
                  color: NuancePalette.success,
                  size: 18,
                ),
              if (isSubmitted && isSelected && !isCorrect)
                const Icon(
                  Icons.cancel_rounded,
                  color: NuancePalette.danger,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpectrumBox extends StatelessWidget {
  const _SpectrumBox({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: count > 0 ? color : color.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count > 0 ? '$count' : '',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _DynamicChallenge {
  const _DynamicChallenge({
    required this.challengeId,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.successText,
    required this.failureText,
    required this.xpReward,
  });

  final String challengeId;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String successText;
  final String failureText;
  final int xpReward;
}
