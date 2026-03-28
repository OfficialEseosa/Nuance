import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nuance/app/nuance_app.dart';
import 'package:nuance/core/data/database_service.dart';
import 'package:nuance/core/data/user_repository.dart';
import 'package:nuance/core/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  
  try {
    // Initialize database
    final databaseService = DatabaseService();
    // Trigger database initialization early
    await databaseService.database;
    
    final userRepository = UserRepository(databaseService);
    
    runApp(
      MultiProvider(
        providers: [
          Provider(create: (_) => userRepository),
          ChangeNotifierProvider(
            create: (_) => UserProvider(userRepository),
          ),
        ],
        child: const NuanceApp(),
      ),
    );
  } catch (e) {
    debugPrint('Fatal error during app initialization: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Fatal error: $e'),
          ),
        ),
      ),
    );
  }
}
