import 'package:flutter/material.dart';
import 'package:nuance/core/data/user_repository.dart';
import 'package:nuance/core/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  final UserRepository _repository;
  bool _isLoading = true;
  String? _error;

  UserProvider(this._repository);

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initializeUser() async {
    try {
      _isLoading = true;
      _error = null;
      _user = await _repository.getOrCreateUser();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUsername(String newUsername) async {
    if (_user == null) return;
    try {
      await _repository.updateUsername(_user!.id!, newUsername);
      _user = _user!.copyWith(username: newUsername);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> addXP(int amount) async {
    if (_user == null) return;
    try {
      await _repository.addXP(_user!.id!, amount);
      // Refresh user data
      _user = await _repository.getUser(_user!.id!);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateStreak(int streak) async {
    if (_user == null) return;
    try {
      await _repository.updateStreak(_user!.id!, streak);
      _user = _user!.copyWith(streak: streak);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> resetStats() async {
    if (_user == null) return;
    try {
      await _repository.resetStats(_user!.id!);
      _user = await _repository.getUser(_user!.id!);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> refreshUser() async {
    if (_user == null) return;
    try {
      _user = await _repository.getUser(_user!.id!);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
