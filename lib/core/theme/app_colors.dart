import 'package:flutter/material.dart';

/// Paleta de colores para el tema de Expedición Ambiental.
/// Inspirada en bosques mágicos, tierras y naturaleza.
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════
  // FONDOS PROFUNDOS (Bosque)
  // ═══════════════════════════════════════════

  /// Verde oscuro profundo - fondo principal del bosque
  static const Color deepForest = Color(0xFF0D2B1D);

  /// Verde bosque medio - capas intermedias
  static const Color forestDark = Color(0xFF1A4D2E);

  /// Verde bosque claro - acentos de fondo
  static const Color forestMid = Color(0xFF2D6A4F);

  // ═══════════════════════════════════════════
  // ACENTOS VIBRANTES (Hojas y naturaleza)
  // ═══════════════════════════════════════════

  /// Verde hoja principal - color de marca
  static const Color leafGreen = Color(0xFF52B788);

  /// Verde neón brillante - highlights y glows
  static const Color neonGreen = Color(0xFF95D5B2);

  /// Dorado tierra - acentos cálidos, monedas
  static const Color goldAccent = Color(0xFFD4A373);

  /// Marrón tierra - elementos rústicos
  static const Color earthBrown = Color(0xFF6B4226);

  // ═══════════════════════════════════════════
  // SUPERFICIES GAMIFICADAS (Cards, HUD)
  // ═══════════════════════════════════════════

  /// Superficie de card oscura
  static const Color cardDark = Color(0xFF1B3A2F);

  /// Superficie de card con efecto cristal
  static const Color cardGlass = Color(0xFF2D4A3E);

  /// Color de highlight/énfasis
  static const Color highlight = Color(0xFF74C69D);

  // ═══════════════════════════════════════════
  // ESTADOS (Feedback visual)
  // ═══════════════════════════════════════════

  /// Éxito - verde vibrante
  static const Color success = Color(0xFF40916C);

  /// Advertencia - amarillo dorado
  static const Color warning = Color(0xFFE9C46A);

  /// Error - coral/rojo suave
  static const Color error = Color(0xFFE76F51);

  // ═══════════════════════════════════════════
  // ELEMENTOS ESPECÍFICOS
  // ═══════════════════════════════════════════

  /// Fondo de botón primario
  static const Color buttonPrimary = Color(0xFF52B788);

  /// Fondo de botón secundario
  static const Color buttonSecondary = Color(0xFF2D6A4F);

  /// Texto sobre fondos oscuros
  static const Color textOnDark = Color(0xFFFFFFFF);

  /// Texto secundario sobre fondos oscuros
  static const Color textSecondaryOnDark = Color(0xFF95D5B2);

  /// Borde sutil para cards
  static const Color borderSubtle = Color(0xFF3D6B54);

  /// Sombra de glow verde
  static Color get glowGreen => leafGreen.withValues(alpha: 0.3);

  /// Sombra de glow dorado
  static Color get glowGold => goldAccent.withValues(alpha: 0.3);

  // ═══════════════════════════════════════════
  // GRADIENTES PRECONSTRUIDOS
  // ═══════════════════════════════════════════

  /// Gradiente principal del bosque (vertical)
  static LinearGradient get forestGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [deepForest, forestDark, deepForest],
  );

  /// Gradiente de card activa
  static LinearGradient get activeCardGradient =>
      const LinearGradient(colors: [cardDark, cardGlass]);

  /// Gradiente de botón primario
  static LinearGradient get primaryButtonGradient =>
      const LinearGradient(colors: [leafGreen, Color(0xFF40916C)]);

  /// Gradiente de madera (para bottom nav, títulos)
  static LinearGradient get woodGradient =>
      const LinearGradient(colors: [earthBrown, Color(0xFF8B5E3C)]);

  /// Gradiente de bloqueo (juegos no disponibles)
  static LinearGradient get lockedGradient =>
      const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)]);
}
