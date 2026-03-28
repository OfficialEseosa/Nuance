import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameActionResult {
  const GameActionResult({
    required this.xpAwarded,
    required this.firstCompletion,
    required this.newlyUnlockedBadges,
  });

  final int xpAwarded;
  final bool firstCompletion;
  final List<String> newlyUnlockedBadges;
}

class GameProgressProvider extends ChangeNotifier {
  static const _completedModulesKey = 'gp_completed_modules';
  static const _comparedStoriesKey = 'gp_compared_stories';
  static const _completedChallengesKey = 'gp_completed_challenges';
  static const _attemptsKey = 'gp_attempts';
  static const _correctAttemptsKey = 'gp_correct_attempts';
  static const _biasFlagsKey = 'gp_bias_flags';
  static const _lastActiveDateKey = 'gp_last_active_date';
  static const _streakDaysKey = 'gp_streak_days';
  static const _unlockedBadgesKey = 'gp_unlocked_badges';

  bool _isLoading = true;
  String? _error;

  Set<String> _completedModules = <String>{};
  Set<String> _comparedStories = <String>{};
  Set<String> _completedChallenges = <String>{};
  Set<String> _unlockedBadges = <String>{};
  int _challengeAttempts = 0;
  int _correctChallengeAttempts = 0;
  int _biasFlags = 0;
  int _streakDays = 0;
  DateTime? _lastActiveDate;

  bool get isLoading => _isLoading;
  String? get error => _error;
  int get completedLessons => _completedModules.length;
  int get storiesCompared => _comparedStories.length;
  int get challengeAttempts => _challengeAttempts;
  int get correctChallengeAttempts => _correctChallengeAttempts;
  int get biasFlags => _biasFlags;
  int get streakDays => _streakDays;
  int get badgesCount => _unlockedBadges.length;
  Set<String> get unlockedBadges => _unlockedBadges;
  int get accuracyPercent {
    if (_challengeAttempts == 0) return 0;
    return ((_correctChallengeAttempts / _challengeAttempts) * 100).round();
  }

  bool isModuleCompleted(String moduleId) {
    return _completedModules.contains(moduleId);
  }

  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _completedModules =
          (prefs.getStringList(_completedModulesKey) ?? const []).toSet();
      _comparedStories = (prefs.getStringList(_comparedStoriesKey) ?? const [])
          .toSet();
      _completedChallenges =
          (prefs.getStringList(_completedChallengesKey) ?? const []).toSet();
      _challengeAttempts = prefs.getInt(_attemptsKey) ?? 0;
      _correctChallengeAttempts = prefs.getInt(_correctAttemptsKey) ?? 0;
      _biasFlags = prefs.getInt(_biasFlagsKey) ?? 0;
      _streakDays = prefs.getInt(_streakDaysKey) ?? 0;
      _unlockedBadges = (prefs.getStringList(_unlockedBadgesKey) ?? const [])
          .toSet();

      final lastActiveRaw = prefs.getString(_lastActiveDateKey);
      _lastActiveDate = lastActiveRaw == null
          ? null
          : DateTime.tryParse(lastActiveRaw);

      _applyBadgeRules();
      await _persist();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<GameActionResult> playModule({
    required String moduleId,
    required int xpReward,
  }) async {
    final newlyUnlocked = <String>[];
    final firstCompletion = _completedModules.add(moduleId);
    final replayXp = (xpReward ~/ 3).clamp(5, xpReward);
    final xpAwarded = firstCompletion ? xpReward : replayXp;

    if (firstCompletion) {
      _biasFlags += 2;
    }

    _recordDailyActivity();
    newlyUnlocked.addAll(_applyBadgeRules());
    await _persist();
    notifyListeners();

    return GameActionResult(
      xpAwarded: xpAwarded,
      firstCompletion: firstCompletion,
      newlyUnlockedBadges: newlyUnlocked,
    );
  }

  Future<GameActionResult> recordStoryComparison({
    required String storyId,
    int xpReward = 5,
  }) async {
    final newlyUnlocked = <String>[];
    final firstCompletion = _comparedStories.add(storyId);
    final xpAwarded = firstCompletion ? xpReward : 0;

    if (firstCompletion) {
      _biasFlags += 1;
    }

    _recordDailyActivity();
    newlyUnlocked.addAll(_applyBadgeRules());
    await _persist();
    notifyListeners();

    return GameActionResult(
      xpAwarded: xpAwarded,
      firstCompletion: firstCompletion,
      newlyUnlockedBadges: newlyUnlocked,
    );
  }

  Future<GameActionResult> submitStoryChallenge({
    required String challengeId,
    required bool correct,
    int xpReward = 20,
  }) async {
    final newlyUnlocked = <String>[];
    _challengeAttempts += 1;
    if (correct) {
      _correctChallengeAttempts += 1;
    }

    final firstCompletion = correct && _completedChallenges.add(challengeId);
    var xpAwarded = 0;
    if (correct) {
      xpAwarded = firstCompletion
          ? xpReward
          : (xpReward ~/ 4).clamp(2, xpReward);
      if (firstCompletion) {
        _biasFlags += 2;
      }
    }

    _recordDailyActivity();
    newlyUnlocked.addAll(_applyBadgeRules());
    await _persist();
    notifyListeners();

    return GameActionResult(
      xpAwarded: xpAwarded,
      firstCompletion: firstCompletion,
      newlyUnlockedBadges: newlyUnlocked,
    );
  }

  Future<void> reset() async {
    _completedModules = <String>{};
    _comparedStories = <String>{};
    _completedChallenges = <String>{};
    _unlockedBadges = <String>{};
    _challengeAttempts = 0;
    _correctChallengeAttempts = 0;
    _biasFlags = 0;
    _streakDays = 0;
    _lastActiveDate = null;
    await _persist();
    notifyListeners();
  }

  void _recordDailyActivity() {
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);

    if (_lastActiveDate == null) {
      _lastActiveDate = today;
      _streakDays = 1;
      return;
    }

    final last = DateTime.utc(
      _lastActiveDate!.year,
      _lastActiveDate!.month,
      _lastActiveDate!.day,
    );
    final diff = today.difference(last).inDays;
    if (diff <= 0) {
      return;
    }
    if (diff == 1) {
      _streakDays += 1;
    } else {
      _streakDays = 1;
    }
    _lastActiveDate = today;
  }

  List<String> _applyBadgeRules() {
    final newlyUnlocked = <String>[];
    void unlockIf(bool condition, String badgeName) {
      if (!condition || _unlockedBadges.contains(badgeName)) return;
      _unlockedBadges.add(badgeName);
      newlyUnlocked.add(badgeName);
    }

    unlockIf(_biasFlags >= 5, 'Frame Finder');
    unlockIf(_comparedStories.length >= 5, 'Cross-Check');
    unlockIf(_correctChallengeAttempts >= 3, 'Neutral Narrator');
    unlockIf(_challengeAttempts >= 8, 'Evidence Scout');

    return newlyUnlocked;
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _completedModulesKey,
        _completedModules.toList(growable: false),
      );
      await prefs.setStringList(
        _comparedStoriesKey,
        _comparedStories.toList(growable: false),
      );
      await prefs.setStringList(
        _completedChallengesKey,
        _completedChallenges.toList(growable: false),
      );
      await prefs.setInt(_attemptsKey, _challengeAttempts);
      await prefs.setInt(_correctAttemptsKey, _correctChallengeAttempts);
      await prefs.setInt(_biasFlagsKey, _biasFlags);
      await prefs.setInt(_streakDaysKey, _streakDays);
      await prefs.setStringList(
        _unlockedBadgesKey,
        _unlockedBadges.toList(growable: false),
      );
      if (_lastActiveDate != null) {
        await prefs.setString(
          _lastActiveDateKey,
          _lastActiveDate!.toIso8601String(),
        );
      } else {
        await prefs.remove(_lastActiveDateKey);
      }
    } catch (e) {
      _error = e.toString();
    }
  }
}
