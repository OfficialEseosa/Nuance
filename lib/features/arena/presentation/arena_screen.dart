import 'package:flutter/material.dart';
import 'package:nuance/core/audio/sound_service.dart';
import 'package:provider/provider.dart';
import 'package:nuance/core/data/mock_content.dart';
import 'package:nuance/core/models/nuance_models.dart';
import 'package:nuance/core/providers/user_provider.dart';
import 'package:nuance/core/theme/nuance_theme.dart';
import 'package:nuance/core/widgets/mascot_bubble.dart';
import 'package:nuance/core/widgets/nuance_card.dart';
import 'package:nuance/core/widgets/nuance_gradient_background.dart';

class ArenaScreen extends StatefulWidget {
  const ArenaScreen({super.key});

  @override
  State<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends State<ArenaScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _progressController;
  late List<AnimationController> _cardControllers;

  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _progressFade;
  late Animation<Offset> _progressSlide;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Create individual controllers for each card
    _cardControllers = List.generate(
      kChallengeModules.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
    );

    // Header animations
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _headerController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Progress animations
    _progressFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );
    _progressSlide =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _progressController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  void _startAnimations() {
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _progressController.forward();
    });

    // Stagger card animations
    for (int i = 0; i < _cardControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 300 + (i * 100)), () {
        if (mounted) {
          _cardControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _headerController.dispose();
    _progressController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<UserProvider>().user;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final completedLessons = user.completedLessons;
    final totalLessons = kChallengeModules.length;
    final completion = totalLessons > 0 ? completedLessons / totalLessons : 0.0;

    return NuanceGradientBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 110),
          children: [
            // Animated Header
            FadeTransition(
              opacity: _headerFade,
              child: SlideTransition(
                position: _headerSlide,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Learn',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
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
                      size: 56,
                      icon: Icons.lightbulb_rounded,
                      iconColor: NuancePalette.warning,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Animated Overall Progress Card
            FadeTransition(
              opacity: _progressFade,
              child: SlideTransition(
                position: _progressSlide,
                child: NuanceCard(
                  borderColor: NuancePalette.cardPurpleBorder,
                  gradientColors: [
                    NuancePalette.cardPurpleBg,
                    const Color(0xFFF3E8FF),
                  ],
                  darkGradientColors: const [
                    NuancePalette.darkCard,
                    NuancePalette.darkSurface,
                  ],
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Overall Progress',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  NuancePalette.warning.withValues(alpha: 0.2),
                                  NuancePalette.warning.withValues(alpha: 0.15),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '$completedLessons/$totalLessons',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: NuancePalette.warning,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: completion,
                          minHeight: 12,
                          color: NuancePalette.secondary,
                          backgroundColor: NuancePalette.isDark(context)
                              ? NuancePalette.darkSecondary
                              : const Color(0xFFE9D5FF),
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
              ),
            ),
            const SizedBox(height: 24),

            // Practice Modules Section
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Practice Modules',
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pick a mode and stack XP.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Animated Challenge Cards
            ...List.generate(kChallengeModules.length, (index) {
              final module = kChallengeModules[index];
              return FadeTransition(
                opacity: _cardControllers[index],
                child: SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _cardControllers[index],
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ChallengeCard(
                      module: module,
                      index: index + 1,
                      completed: index == 0,
                      locked: index == 2,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatefulWidget {
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

  @override
  State<_ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<_ChallengeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _elevation;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _elevation = Tween<double>(begin: 0, end: 4).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _offset = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.08))
        .animate(
          CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  Color get _difficultyColor {
    switch (widget.module.difficulty) {
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

    return MouseRegion(
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: SlideTransition(
        position: _offset,
        child: AnimatedBuilder(
          animation: _elevation,
          builder: (context, child) {
            return NuanceCard(
              borderColor: widget.completed
                  ? NuancePalette.success.withValues(alpha: 0.6)
                  : widget.locked
                  ? const Color(0xFFD1D5DB)
                  : _difficultyColor.withValues(alpha: 0.45),
              backgroundColor: widget.completed
                  ? const Color(0xFFECFDF5)
                  : Colors.white,
              darkGradientColors: const [
                NuancePalette.darkCard,
                NuancePalette.darkSurface,
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: widget.completed
                                ? [
                                    const Color(0xFF22C55E),
                                    const Color(0xFF16A34A),
                                  ]
                                : widget.locked
                                ? [
                                    const Color(0xFF9CA3AF),
                                    const Color(0xFF6B7280),
                                  ]
                                : [
                                    NuancePalette.primary,
                                    NuancePalette.secondary,
                                  ],
                          ),
                          boxShadow: [
                            if (_elevation.value > 0)
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: 0.1 * _elevation.value,
                                ),
                                blurRadius: 4,
                                offset: Offset(0, _elevation.value),
                              ),
                          ],
                        ),
                        child: widget.completed
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 20,
                              )
                            : widget.locked
                            ? const Icon(
                                Icons.lock_rounded,
                                color: Colors.white,
                                size: 20,
                              )
                            : Text(
                                '${widget.index}',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.module.title,
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.module.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: widget.locked
                                    ? NuancePalette.mutedInk
                                    : NuancePalette.mutedInk,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
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
                          widget.module.difficulty,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: _difficultyColor,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              color: NuancePalette.mutedInk,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.module.duration,
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.stars_rounded,
                              color: NuancePalette.secondary,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '+${widget.module.xpReward} XP',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton.tonal(
                        onPressed: widget.locked
                            ? null
                            : () {
                                if (widget.completed) {
                                  SoundService.instance.playPop();
                                } else {
                                  SoundService.instance.playTap();
                                }
                              },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          widget.locked
                              ? 'Locked'
                              : widget.completed
                              ? 'Replay'
                              : 'Play',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
