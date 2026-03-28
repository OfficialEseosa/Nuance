import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nuance/core/theme/nuance_theme.dart';
import 'package:nuance/core/providers/user_provider.dart';
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

  static const _tabs = [
    _ShellTab(icon: Icons.home_rounded, label: 'Home'),
    _ShellTab(icon: Icons.newspaper_rounded, label: 'News'),
    _ShellTab(icon: Icons.menu_book_rounded, label: 'Learn'),
    _ShellTab(icon: Icons.person_rounded, label: 'Profile'),
    _ShellTab(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize user data when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().initializeUser();
    });
  }

  void _openStoryCompare() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const StoryCompareScreen()));
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
                padding: const EdgeInsets.all(24.0),
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
                        color: Colors.red,
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

        final screens = [
          const PathScreen(),
          LensScreen(onOpenStoryCompare: _openStoryCompare),
          const ArenaScreen(),
          const ProfileScreen(),
          SettingsScreen(
            user: user,
            onUsernameChanged: (newUsername) {
              userProvider.updateUsername(newUsername);
            },
            onResetStats: () {
              userProvider.resetStats();
            },
          ),
        ];

        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          body: IndexedStack(index: _selectedIndex, children: screens),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? NuancePalette.darkSurface : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDarkMode
                        ? NuancePalette.darkSecondary
                        : const Color(0xFFE5E7EB),
                    width: 2,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(isDarkMode ? 0x1AFFFFFF : 0x1A000000),
                    blurRadius: 24,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_tabs.length, (index) {
                  final tab = _tabs[index];
                  final active = _selectedIndex == index;
                  final tint = active
                      ? (isDarkMode
                          ? NuancePalette.darkTertiary
                          : NuancePalette.primary)
                      : (isDarkMode
                          ? NuancePalette.darkMutedText
                          : NuancePalette.mutedInk);

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => setState(() => _selectedIndex = index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(tab.icon, color: tint, size: 24),
                          const SizedBox(height: 4),
                          Text(
                            tab.label,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: tint,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 3),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: active ? tint : Colors.transparent,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ShellTab {
  const _ShellTab({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
