import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:nuance/app/nuance_app.dart';
import 'package:nuance/core/providers/user_provider.dart';
import 'package:nuance/core/models/user_model.dart';

class MockUserProvider extends ChangeNotifier implements UserProvider {
  final UserModel _user = UserModel(
    id: 1, 
    username: 'Test', 
    level: 1, 
    xp: 0, 
    streak: 0, 
    totalXp: 0, 
    completedLessons: 0, 
    badges: 0, 
    createdAt: DateTime.now(), 
    updatedAt: DateTime.now()
  );
  
  @override
  UserModel? get user => _user;
  
  @override
  bool get isLoading => false;
  
  @override
  String? get error => null;
  
  @override
  Future<void> initializeUser() async {}

  @override
  Future<void> updateUsername(String newUsername) async {}
  @override
  Future<void> addXP(int amount) async {}
  @override
  Future<void> updateStreak(int streak) async {}
  @override
  Future<void> resetStats() async {}
  @override
  Future<void> refreshUser() async {}
}

void main() {
  testWidgets('Nuance shell renders primary tabs', (tester) async {
    final mockProvider = MockUserProvider();
    
    await tester.pumpWidget(
      ChangeNotifierProvider<UserProvider>.value(
        value: mockProvider,
        child: const NuanceApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('News'), findsOneWidget);
    expect(find.text('Learn'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
