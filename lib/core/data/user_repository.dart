import 'package:flutter/foundation.dart';
import 'package:nuance/core/data/database_service.dart';
import 'package:nuance/core/models/user_model.dart';

class UserRepository {
  final DatabaseService _databaseService;

  UserRepository(this._databaseService);

  Future<UserModel> getOrCreateUser() async {
    try {
      final db = await _databaseService.database;
      final users = await db.query('users', limit: 1);
      debugPrint('DEBUG: Found ${users.length} users in database');

      if (users.isNotEmpty) {
        debugPrint('DEBUG: Returning existing user');
        return UserModel.fromJson(users.first as Map<String, dynamic>);
      } else {
        debugPrint('DEBUG: Creating new default user');
        // Create default user
        final newUser = UserModel(
          username: 'Player',
          level: 1,
          xp: 0,
          streak: 0,
          totalXp: 0,
          completedLessons: 0,
          badges: 0,
        );

        final id = await db.insert('users', newUser.toJson());
        debugPrint('DEBUG: Created user with id: $id');
        return newUser.copyWith(id: id);
      }
    } catch (e) {
      debugPrint('DEBUG ERROR in getOrCreateUser: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUser(int id) async {
    final db = await _databaseService.database;
    final results = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (results.isNotEmpty) {
      return UserModel.fromJson(results.first as Map<String, dynamic>);
    }
    return null;
  }

  Future<int> updateUser(UserModel user) async {
    final db = await _databaseService.database;
    return await db.update(
      'users',
      user.copyWith(updatedAt: DateTime.now()).toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> updateUsername(int userId, String newUsername) async {
    final db = await _databaseService.database;
    await db.update(
      'users',
      {'username': newUsername, 'updatedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> addXP(int userId, int amount) async {
    final user = await getUser(userId);
    if (user != null) {
      int newXp = user.xp + amount;
      int newTotalXp = user.totalXp + amount;
      int newLevel = user.level;

      // Level up every 100 XP
      while (newXp >= 100) {
        newXp -= 100;
        newLevel += 1;
      }

      await updateUser(
        user.copyWith(xp: newXp, totalXp: newTotalXp, level: newLevel),
      );
    }
  }

  Future<void> updateStreak(int userId, int streak) async {
    final db = await _databaseService.database;
    await db.update(
      'users',
      {'streak': streak, 'updatedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> resetStats(int userId) async {
    final db = await _databaseService.database;
    await db.update(
      'users',
      {
        'level': 1,
        'xp': 0,
        'streak': 0,
        'totalXp': 0,
        'completedLessons': 0,
        'badges': 0,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
