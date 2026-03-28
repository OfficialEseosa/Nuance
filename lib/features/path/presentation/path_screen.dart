import 'package:flutter/material.dart';
import 'package:nuance/core/theme/nuance_theme.dart';
import 'package:nuance/core/widgets/mascot_bubble.dart';
import 'package:nuance/core/widgets/nuance_card.dart';
import 'package:nuance/core/widgets/nuance_gradient_background.dart';

class PathScreen extends StatefulWidget {
  const PathScreen({super.key});

  @override
  State<PathScreen> createState() => _PathScreenState();
}

class _PathScreenState extends State<PathScreen>
    with TickerProviderStateMixin {
  late AnimationController _greetingController;
  late AnimationController _statsController;
  late AnimationController _progressController;
  late AnimationController _trendingController;
  late AnimationController _pulseController;

  late Animation<double> _greetingFade;
  late Animation<Offset> _greetingSlide;
  late Animation<double> _statsFade;
  late Animation<Offset> _statsSlide;
  late Animation<double> _progressFade;
  late Animation<Offset> _progressSlide;
  late Animation<double> _trendingFade;
  late Animation<Offset> _trendingSlide;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _greetingController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _statsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _trendingController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Greeting animation
    _greetingFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _greetingController, curve: Curves.easeOut),
    );
    _greetingSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _greetingController, curve: Curves.easeOutCubic),
    );

    // Stats animation
    _statsFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _statsController, curve: Curves.easeOut),
    );
    _statsSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _statsController, curve: Curves.easeOutCubic),
    );

    // Progress animation
    _progressFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );
    _progressSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );

    // Trending animation
    _trendingFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _trendingController, curve: Curves.easeOut),
    );
    _trendingSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _trendingController, curve: Curves.easeOutCubic),
    );

    // Pulse animation for mascot

    _pulse = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    _greetingController.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _statsController.forward();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _progressController.forward();
    });
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) _trendingController.forward();
    });
  }

  @override
  void dispose() {
    _greetingController.dispose();
    _statsController.dispose();
    _progressController.dispose();
    _trendingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NuanceGradientBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 110),
          children: [
            // Animated Greeting Header
            FadeTransition(
              opacity: _greetingFade,
              child: SlideTransition(
                position: _greetingSlide,
                child: Row(
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
                    ScaleTransition(
                      scale: _pulse,
                      child: const MascotBubble(size: 56),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Animated Stats Cards
            FadeTransition(
              opacity: _statsFade,
              child: SlideTransition(
                position: _statsSlide,
                child: Row(
                  children: const [
                    Expanded(
                      child: _TopStatCard(
                        label: 'Streak',
                        value: '7',
                        footnote: 'days',
                        icon: Icons.local_fire_department_rounded,
                        borderColor: NuancePalette.cardOrangeBorder,
                        gradientColors: [
                          NuancePalette.cardOrangeBg,
                          Color(0xFFFCD34D)
                        ],
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
                        gradientColors: [
                          NuancePalette.cardYellowBg,
                          Color(0xFFFCD34D)
                        ],
                        textColor: NuancePalette.yellowText,
                        iconColor: Color(0xFFDCBA34),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Animated XP Progress Card
            FadeTransition(
              opacity: _progressFade,
              child: SlideTransition(
                position: _progressSlide,
                child: NuanceCard(
                  borderColor: NuancePalette.cardPurpleBorder,
                  gradientColors: [
                    NuancePalette.cardPurpleBg,
                    const Color(0xFFF3E8FF)
                  ],
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
                            style: theme.textTheme.labelLarge
                                ?.copyWith(fontSize: 14),
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
              ),
            ),
            const SizedBox(height: 16),

            // Animated Trending Card
            FadeTransition(
              opacity: _trendingFade,
              child: SlideTransition(
                position: _trendingSlide,
                child: NuanceCard(
                  borderColor: NuancePalette.cardRedBorder,
                  gradientColors: [
                    NuancePalette.cardRedBg,
                    const Color(0xFFFEE2E2)
                  ],
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
              ),
            ),
            const SizedBox(height: 24),

            // Quick Action Button
            FadeTransition(
              opacity: _trendingFade,
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: NuancePalette.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.school_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Start Learning',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
