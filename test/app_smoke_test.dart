import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:nuance/app/nuance_app.dart';
import 'package:nuance/core/data/news_service.dart';
import 'package:nuance/core/models/news_story.dart';
import 'package:nuance/core/providers/game_progress_provider.dart';
import 'package:nuance/core/providers/news_provider.dart';
import 'package:nuance/core/providers/user_provider.dart';
import 'package:nuance/core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    updatedAt: DateTime.now(),
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
  @override
  Future<void> syncProgress({
    int? streak,
    int? completedLessons,
    int? badges,
  }) async {}
}

class FakeNewsService extends NewsService {
  @override
  Future<List<NewsStory>> fetchLatestStories({int limit = 24}) async {
    return [
      NewsStory(
        id: 't1',
        source: 'Test Wire',
        leaning: 'Center',
        title: 'Test story',
        summary: 'Summary',
        url: 'https://example.com',
        publishedAt: DateTime.now().toUtc(),
        category: 'World',
        credibilityScore: 90,
      ),
    ];
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Nuance shell renders primary tabs', (tester) async {
    final mockProvider = MockUserProvider();
    final newsProvider = NewsProvider(FakeNewsService());
    final gameProgressProvider = GameProgressProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>.value(value: mockProvider),
          ChangeNotifierProvider<NewsProvider>.value(value: newsProvider),
          ChangeNotifierProvider<GameProgressProvider>.value(
            value: gameProgressProvider,
          ),
        ],
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
