import 'package:flutter/material.dart';
import 'package:nuance/core/audio/sound_service.dart';
import 'package:nuance/core/models/user_model.dart';
import 'package:nuance/core/providers/theme_provider.dart';
import 'package:nuance/core/theme/nuance_theme.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  final UserModel user;
  final Function(String) onUsernameChanged;
  final Function() onResetStats;

  const SettingsScreen({
    required this.user,
    required this.onUsernameChanged,
    required this.onResetStats,
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _usernameController;
  late bool _soundEnabled;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _soundEnabled = SoundService.instance.enabled;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _saveUsername() {
    final newUsername = _usernameController.text.trim();
    if (newUsername.isNotEmpty && newUsername != widget.user.username) {
      widget.onUsernameChanged(newUsername);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username updated to $newUsername'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _confirmReset() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Statistics'),
        content: const Text(
          'Are you sure you want to reset all your statistics? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onResetStats();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Statistics reset successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: NuancePalette.danger),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleSoundEffects(bool value) async {
    setState(() => _soundEnabled = value);
    await SoundService.instance.setEnabled(value);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value ? 'Sound effects enabled' : 'Sound effects muted'),
        duration: const Duration(milliseconds: 1400),
      ),
    );
  }

  Future<void> _toggleThemeMode(bool useDarkMode) async {
    final mode = useDarkMode ? ThemeMode.dark : ThemeMode.light;
    await context.read<ThemeProvider>().setThemeMode(mode);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(useDarkMode ? 'Dark mode enabled' : 'Light mode enabled'),
        duration: const Duration(milliseconds: 1400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        children: [
          // Username Section
          Text(
            'Profile',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? NuancePalette.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode
                    ? NuancePalette.darkSecondary
                    : NuancePalette.border,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _usernameController,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Enter your username',
                    hintStyle: theme.textTheme.bodySmall,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDarkMode
                            ? NuancePalette.darkSecondary
                            : NuancePalette.border,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDarkMode
                            ? NuancePalette.darkSecondary
                            : NuancePalette.border,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: NuancePalette.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? NuancePalette.darkBg
                        : const Color(0xFFFAFAFA),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLength: 30,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saveUsername,
                    child: const Text('Save Username'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Experience Section
          Text(
            'Experience',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? NuancePalette.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode
                    ? NuancePalette.darkSecondary
                    : NuancePalette.border,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? NuancePalette.darkSecondary
                        : const Color(0xFFF4F6FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.music_note_rounded,
                    color: isDarkMode
                        ? NuancePalette.darkAccent
                        : NuancePalette.accentBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sound Effects',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Play tap and reward sounds during gameplay.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: _soundEnabled,
                  onChanged: _toggleSoundEffects,
                  activeThumbColor: NuancePalette.primary,
                  activeTrackColor: NuancePalette.primary.withValues(
                    alpha: 0.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? NuancePalette.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode
                    ? NuancePalette.darkSecondary
                    : NuancePalette.border,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? NuancePalette.darkSecondary
                        : const Color(0xFFF4F6FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isDarkMode
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    color: isDarkMode
                        ? NuancePalette.darkAccent
                        : NuancePalette.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dark Mode',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Switch between dark and light themes.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: isDarkMode,
                  onChanged: _toggleThemeMode,
                  activeThumbColor: NuancePalette.primary,
                  activeTrackColor: NuancePalette.primary.withValues(
                    alpha: 0.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Statistics Section
          Text(
            'Statistics',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? NuancePalette.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode
                    ? NuancePalette.darkSecondary
                    : NuancePalette.border,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Level', style: theme.textTheme.labelMedium),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.user.level}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total XP', style: theme.textTheme.labelMedium),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.user.totalXp}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Streak', style: theme.textTheme.labelMedium),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.user.streak}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: NuancePalette.danger,
                    ),
                    onPressed: _confirmReset,
                    child: const Text('Reset All Statistics'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // About Section
          Text(
            'About',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? NuancePalette.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode
                    ? NuancePalette.darkSecondary
                    : NuancePalette.border,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('App Version', style: theme.textTheme.bodyMedium),
                    Text('1.0.0', style: theme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Member Since', style: theme.textTheme.bodyMedium),
                    Text(
                      _formatDate(widget.user.createdAt),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
