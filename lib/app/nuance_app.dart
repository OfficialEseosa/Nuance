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
      home: const NuanceShell(),
    );
  }
}
