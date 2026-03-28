import 'package:flutter/material.dart';
import 'package:nuance/core/audio/sound_service.dart';
import 'package:nuance/core/data/mock_content.dart';
import 'package:nuance/core/providers/user_provider.dart';
import 'package:nuance/core/theme/nuance_theme.dart';
import 'package:nuance/core/widgets/nuance_card.dart';
import 'package:nuance/core/widgets/nuance_gradient_background.dart';
import 'package:provider/provider.dart';

class StoryCompareScreen extends StatefulWidget {
  const StoryCompareScreen({super.key});

  @override
  State<StoryCompareScreen> createState() => _StoryCompareScreenState();
}

class _StoryCompareScreenState extends State<StoryCompareScreen> {
  static const int _correctAnswerIndex = 0;

  int? _selectedAnswerIndex;
  bool _submitted = false;
  bool _rewardClaimed = false;

  void _selectAnswer(int index) {
    if (_submitted) return;
    SoundService.instance.playTap();
    setState(() => _selectedAnswerIndex = index);
  }

  Future<void> _submitAnswer() async {
    if (_selectedAnswerIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pick an answer before submitting.'),
          duration: Duration(milliseconds: 1400),
        ),
      );
      return;
    }

    final isCorrect = _selectedAnswerIndex == _correctAnswerIndex;
    setState(() => _submitted = true);

    if (isCorrect) {
      SoundService.instance.playSuccess();
      if (!_rewardClaimed) {
        await context.read<UserProvider>().addXP(20);
        if (!mounted) return;
        setState(() => _rewardClaimed = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Correct. +20 XP'),
            duration: Duration(milliseconds: 1400),
          ),
        );
      }
      return;
    }

    SoundService.instance.playPop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Not quite. Try again.'),
        duration: Duration(milliseconds: 1400),
      ),
    );
  }

  void _resetChallenge() {
    SoundService.instance.playTap();
    setState(() {
      _selectedAnswerIndex = null;
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = NuancePalette.isDark(context);
    final isCorrect = _selectedAnswerIndex == _correctAnswerIndex;

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
                    'Main Story',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: NuancePalette.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Senate climate package passes after high-stakes vote.',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Goal: identify what each outlet emphasizes, omits, or frames emotionally.',
                    style: theme.textTheme.bodySmall,
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
                    children: const [
                      _SpectrumBox(
                        label: 'L',
                        count: 1,
                        color: Color(0xFF2563EB),
                      ),
                      SizedBox(width: 6),
                      _SpectrumBox(
                        label: 'CL',
                        count: 1,
                        color: Color(0xFF60A5FA),
                      ),
                      SizedBox(width: 6),
                      _SpectrumBox(
                        label: 'C',
                        count: 1,
                        color: Color(0xFF9CA3AF),
                      ),
                      SizedBox(width: 6),
                      _SpectrumBox(
                        label: 'CR',
                        count: 0,
                        color: Color(0xFFFCA5A5),
                      ),
                      SizedBox(width: 6),
                      _SpectrumBox(
                        label: 'R',
                        count: 0,
                        color: Color(0xFFEF4444),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                  child: _CoveragePanel(
                    title: 'Center-Left Focus',
                    points: [
                      'Affordability and health outcomes',
                      'Community-level effects in cities',
                      'Less emphasis on business compliance costs',
                    ],
                    tone: Color(0xFF2563EB),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _CoveragePanel(
                    title: 'Center-Right Focus',
                    points: [
                      'Regulatory burden for local industries',
                      'Short-term tax pressure concerns',
                      'Less emphasis on urban public health benefits',
                    ],
                    tone: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            NuanceCard(
              borderColor: const Color(0xFFD8B4FE),
              darkGradientColors: const [
                NuancePalette.darkCard,
                NuancePalette.darkSurface,
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nuance Challenge', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Which missing context would make both narratives more complete?',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  _AnswerOption(
                    label: 'A',
                    answerText: 'Long-term grid infrastructure timeline',
                    isDark: isDark,
                    isSelected: _selectedAnswerIndex == 0,
                    isSubmitted: _submitted,
                    isCorrect: true,
                    onTap: () => _selectAnswer(0),
                  ),
                  _AnswerOption(
                    label: 'B',
                    answerText: 'List of political endorsements only',
                    isDark: isDark,
                    isSelected: _selectedAnswerIndex == 1,
                    isSubmitted: _submitted,
                    isCorrect: false,
                    onTap: () => _selectAnswer(1),
                  ),
                  _AnswerOption(
                    label: 'C',
                    answerText: 'Unverified social media reactions',
                    isDark: isDark,
                    isSelected: _selectedAnswerIndex == 2,
                    isSubmitted: _submitted,
                    isCorrect: false,
                    onTap: () => _selectAnswer(2),
                  ),
                  if (_submitted) ...[
                    const SizedBox(height: 2),
                    Text(
                      isCorrect
                          ? 'Great catch. This adds structural context to both narratives.'
                          : 'Hint: pick the option that adds verifiable context, not opinion noise.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isCorrect
                            ? NuancePalette.success
                            : NuancePalette.warning,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: _submitAnswer,
                          child: Text(
                            _rewardClaimed
                                ? 'Challenge Completed'
                                : 'Submit and earn 20 XP',
                          ),
                        ),
                      ),
                      if (_submitted && !isCorrect) ...[
                        const SizedBox(width: 8),
                        FilledButton.tonal(
                          onPressed: _resetChallenge,
                          child: const Text('Retry'),
                        ),
                      ],
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
                  Text('Tracked Sources', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  ...kStoryPerspectives.map(
                    (source) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.public_rounded,
                            color: NuancePalette.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(source.source)),
                          Text(
                            source.leaning,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: NuancePalette.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
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
    Color bgColor = baseBg;
    Color borderColor = isDark
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
