import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.green,
      scaffoldBackgroundColor: const Color(0xFFF7F8F4),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );
  }
}
