import 'package:flutter/material.dart';
import 'package:nuance/core/theme/nuance_theme.dart';
import 'package:nuance/features/arena/presentation/arena_screen.dart';
import 'package:nuance/features/lens/presentation/lens_screen.dart';
import 'package:nuance/features/lens/presentation/story_compare_screen.dart';
import 'package:nuance/features/path/presentation/path_screen.dart';
import 'package:nuance/features/profile/presentation/profile_screen.dart';

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
  ];

  late final List<Widget> _screens = [
    const PathScreen(),
    LensScreen(onOpenStoryCompare: _openStoryCompare),
    const ArenaScreen(),
    const ProfileScreen(),
  ];

  void _openStoryCompare() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const StoryCompareScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 2)),
            boxShadow: [
              BoxShadow(
                color: Color(0x16000000),
                blurRadius: 18,
                offset: Offset(0, -6),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabs.length, (index) {
              final tab = _tabs[index];
              final active = _selectedIndex == index;
              final tint = active
                  ? NuancePalette.primary
                  : NuancePalette.mutedInk;

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => setState(() => _selectedIndex = index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(tab.icon, color: tint),
                      const SizedBox(height: 4),
                      Text(
                        tab.label,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: tint,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: active
                              ? NuancePalette.primary
                              : Colors.transparent,
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
  }
}

class _ShellTab {
  const _ShellTab({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
