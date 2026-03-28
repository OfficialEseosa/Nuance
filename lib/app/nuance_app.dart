import 'package:flutter/material.dart';
import 'package:nuance/app/nuance_shell.dart';
import 'package:nuance/core/providers/theme_provider.dart';
import 'package:nuance/core/theme/nuance_theme.dart';
import 'package:provider/provider.dart';

class NuanceApp extends StatelessWidget {
  const NuanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Nuance',
      debugShowCheckedModeBanner: false,
      theme: buildNuanceTheme(),
      darkTheme: buildNuanceDarkTheme(),
      themeMode: themeProvider.themeMode,
      home: const NuanceShell(),
    );
  }
}
