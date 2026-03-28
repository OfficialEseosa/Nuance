import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nuance/core/audio/sound_service.dart';
import 'package:nuance/core/models/news_cluster.dart';
import 'package:nuance/core/models/news_story.dart';
import 'package:nuance/core/providers/game_progress_provider.dart';
import 'package:nuance/core/providers/news_provider.dart';
import 'package:nuance/core/providers/user_provider.dart';
import 'package:nuance/core/theme/nuance_theme.dart';
import 'package:nuance/features/arena/presentation/arena_screen.dart';
import 'package:nuance/features/lens/presentation/lens_screen.dart';
import 'package:nuance/features/lens/presentation/story_compare_screen.dart';
import 'package:nuance/features/path/presentation/path_screen.dart';
import 'package:nuance/features/profile/presentation/profile_screen.dart';
import 'package:nuance/features/settings/presentation/settings_screen.dart';

class NuanceShell extends StatefulWidget {
  const NuanceShell({super.key});

  @override
  State<NuanceShell> createState() => _NuanceShellState();
}

class _NuanceShellState extends State<NuanceShell> {
  int _selectedIndex = 0;
  bool _bootstrapped = false;

  static const _tabs = [
    _ShellTab(
      icon: Icons.home_rounded,
      label: 'Home',
      accent: Color(0xFF58CC02),
    ),
    _ShellTab(
      icon: Icons.newspaper_rounded,
      label: 'News',
      accent: Color(0xFF1CB0F6),
    ),
    _ShellTab(
      icon: Icons.menu_book_rounded,
      label: 'Learn',
      accent: Color(0xFFFFC800),
    ),
    _ShellTab(
      icon: Icons.person_rounded,
      label: 'Profile',
      accent: Color(0xFFA560FF),
    ),
    _ShellTab(
      icon: Icons.settings_rounded,
      label: 'Settings',
      accent: Color(0xFF8EA4AE),
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    if (_bootstrapped) return;
    _bootstrapped = true;

    final userProvider = context.read<UserProvider>();
    final newsProvider = context.read<NewsProvider>();
    final progressProvider = context.read<GameProgressProvider>();

    await userProvider.initializeUser();
    await Future.wait([
      newsProvider.initialize(),
      progressProvider.initialize(),
    ]);

    await userProvider.syncProgress(
      streak: progressProvider.streakDays,
      completedLessons: progressProvider.completedLessons,
      badges: progressProvider.badgesCount,
    );
  }

  void _openStoryCompare({NewsStory? story, NewsCluster? cluster}) {
    SoundService.instance.playTap();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StoryCompareScreen(story: story, cluster: cluster),
      ),
    );
  }

  void _openLearnTab() {
    if (_selectedIndex == 2) {
      SoundService.instance.playPop();
      return;
    }
    setState(() => _selectedIndex = 2);
  }

  void _onSelectTab(int index) {
    if (_selectedIndex == index) {
      SoundService.instance.playPop();
      return;
    }
    SoundService.instance.playTap();
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.isLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }

        if (userProvider.user == null) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error loading user',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userProvider.error ?? 'Unknown error',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: NuancePalette.danger,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final user = userProvider.user!;
        final isDark = NuancePalette.isDark(context);

        final screens = [
          PathScreen(
            onOpenStoryCompare: _openStoryCompare,
            onStartLearning: _openLearnTab,
          ),
          LensScreen(onOpenStoryCompare: _openStoryCompare),
          const ArenaScreen(),
          const ProfileScreen(),
          SettingsScreen(
            user: user,
            onUsernameChanged: (newUsername) =>
                userProvider.updateUsername(newUsername),
            onResetStats: () {
              userProvider.resetStats();
              context.read<GameProgressProvider>().reset();
            },
          ),
        ];

        return Scaffold(
          body: IndexedStack(index: _selectedIndex, children: screens),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? const [Color(0xFF1E2B33), Color(0xFF18242C)]
                        : const [Color(0xFFFFFFFF), Color(0xFFF7FAFC)],
                  ),
                  border: Border.all(
                    color: NuancePalette.borderColor(context),
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x2A000000),
                      blurRadius: 22,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: List.generate(_tabs.length, (index) {
                    final tab = _tabs[index];
                    return Expanded(
                      child: _DockItem(
                        tab: tab,
                        active: _selectedIndex == index,
                        isDark: isDark,
                        onTap: () => _onSelectTab(index),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ShellTab {
  const _ShellTab({
    required this.icon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final Color accent;
}

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.tab,
    required this.active,
    required this.isDark,
    required this.onTap,
  });

  final _ShellTab tab;
  final bool active;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final inactiveColor = isDark
        ? NuancePalette.darkMutedText
        : NuancePalette.mutedInk;
    final iconBgColor = isDark
        ? NuancePalette.darkSecondary
        : const Color(0xFFEFF3F6);

    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutBack,
      scale: active ? 1.07 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: active ? null : iconBgColor,
                  gradient: active
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            tab.accent,
                            tab.accent.withValues(alpha: 0.7),
                          ],
                        )
                      : null,
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: tab.accent.withValues(alpha: 0.34),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  tab.icon,
                  size: 23,
                  color: active ? const Color(0xFF102026) : inactiveColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tab.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: active ? tab.accent : inactiveColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: active ? 18 : 0,
                height: 4,
                decoration: BoxDecoration(
                  color: active ? tab.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
