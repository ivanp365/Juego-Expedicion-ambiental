import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'router.dart'; // ← nuevo import (mismo folder: lib/app/router.dart)

class ExpedicionAmbientalApp extends StatelessWidget {
  const ExpedicionAmbientalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Expedición Ambiental',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter, // ← viene de router.dart
    );
  }
}
