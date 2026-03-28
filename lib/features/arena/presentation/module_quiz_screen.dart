import 'package:flutter/material.dart';
import 'package:nuance/core/audio/sound_service.dart';
import 'package:nuance/core/models/nuance_models.dart';
import 'package:nuance/core/theme/nuance_theme.dart';
import 'package:nuance/core/widgets/nuance_card.dart';
import 'package:nuance/core/widgets/nuance_gradient_background.dart';

class ModuleQuizResult {
  const ModuleQuizResult({required this.correct});

  final bool correct;
}

class ModuleQuizScreen extends StatefulWidget {
  const ModuleQuizScreen({
    required this.module,
    required this.question,
    super.key,
  });

  final ChallengeModule module;
  final ChallengeQuestion question;

  @override
  State<ModuleQuizScreen> createState() => _ModuleQuizScreenState();
}

class _ModuleQuizScreenState extends State<ModuleQuizScreen> {
  int? _selectedIndex;
  bool _submitted = false;
  bool _correct = false;

  void _select(int index) {
    if (_submitted) return;
    SoundService.instance.playTap();
    setState(() => _selectedIndex = index);
  }

  void _submit() {
    if (_selectedIndex == null) return;
    final correct = _selectedIndex == widget.question.correctIndex;
    setState(() {
      _submitted = true;
      _correct = correct;
    });
    if (correct) {
      SoundService.instance.playSuccess();
    } else {
      SoundService.instance.playPop();
    }
  }

  void _finish() {
    Navigator.of(context).pop(ModuleQuizResult(correct: _correct));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.module.title)),
      body: NuanceGradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mini Game', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Text(
                    widget.question.prompt,
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(widget.question.options.length, (index) {
              final option = widget.question.options[index];
              final selected = _selectedIndex == index;
              final correctOption = index == widget.question.correctIndex;
              var borderColor = NuancePalette.borderColor(context);
              var bgColor = NuancePalette.isDark(context)
                  ? NuancePalette.darkSecondary
                  : const Color(0xFFF8FAFC);

              if (_submitted && correctOption) {
                borderColor = NuancePalette.success;
                bgColor = NuancePalette.success.withValues(alpha: 0.15);
              } else if (_submitted && selected && !correctOption) {
                borderColor = NuancePalette.danger;
                bgColor = NuancePalette.danger.withValues(alpha: 0.14);
              } else if (selected) {
                borderColor = NuancePalette.primary;
                bgColor = NuancePalette.primary.withValues(alpha: 0.15);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _select(index),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: Text(option, style: theme.textTheme.bodyMedium),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            if (_submitted)
              Text(
                widget.question.explanation,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _correct
                      ? NuancePalette.success
                      : NuancePalette.warning,
                  fontWeight: FontWeight.w700,
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submitted ? _finish : _submit,
                child: Text(_submitted ? 'Continue' : 'Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
