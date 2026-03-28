import 'package:flutter/material.dart';
import 'package:nuance/app/nuance_shell.dart';
import 'package:nuance/core/theme/nuance_theme.dart';

class NuanceApp extends StatelessWidget {
  const NuanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nuance',
      debugShowCheckedModeBanner: false,
      theme: buildNuanceTheme(),
      darkTheme: buildNuanceDarkTheme(),
      themeMode: ThemeMode.dark, // Default to dark mode
      home: const NuanceShell(),
    );
  }
}
