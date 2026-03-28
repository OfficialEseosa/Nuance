import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nuance/app/nuance_app.dart';
import 'package:nuance/core/audio/sound_service.dart';
import 'package:nuance/core/data/database_service.dart';
import 'package:nuance/core/data/news_service.dart';
import 'package:nuance/core/providers/game_progress_provider.dart';
import 'package:nuance/core/providers/news_provider.dart';
import 'package:nuance/core/data/user_repository.dart';
import 'package:nuance/core/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  try {
    await SoundService.instance.initialize();

    // Initialize database
    final databaseService = DatabaseService();
    // Trigger database initialization early
    await databaseService.database;

    final userRepository = UserRepository(databaseService);
    final newsService = NewsService();

    runApp(
      MultiProvider(
        providers: [
          Provider(create: (_) => userRepository),
          Provider(create: (_) => newsService),
          ChangeNotifierProvider(create: (_) => UserProvider(userRepository)),
          ChangeNotifierProvider(create: (_) => NewsProvider(newsService)),
          ChangeNotifierProvider(create: (_) => GameProgressProvider()),
        ],
        child: const NuanceApp(),
      ),
    );
  } catch (e) {
    debugPrint('Fatal error during app initialization: $e');
    runApp(
      MaterialApp(
        home: Scaffold(body: Center(child: Text('Fatal error: $e'))),
      ),
    );
  }
}
