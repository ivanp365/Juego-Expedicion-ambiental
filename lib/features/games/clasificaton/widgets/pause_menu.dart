import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Menú de pausa glassmorphic con animaciones profesionales.
/// Aparece centrado con fade + scale sobre el fondo oscurecido.
class PauseMenuOverlay extends StatelessWidget {
  const PauseMenuOverlay({
    super.key,
    required this.onResume,
    required this.onShowExit,
  });

  final VoidCallback onResume;
  final VoidCallback onShowExit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child:
            Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xff111d32).withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: const Color(0xff79E5B0).withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Icono de pausa
                      const Center(
                        child: Icon(
                          Icons.pause_circle_filled_rounded,
                          color: Color(0xff79E5B0),
                          size: 56,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Título
                      const Text(
                        'JUEGO EN PAUSA',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subtítulo
                      const Text(
                        'La expedición está detenida.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xffB8D8E8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Botón Continuar
                      ElevatedButton.icon(
                        onPressed: onResume,
                        icon: const Icon(Icons.play_arrow_rounded, size: 24),
                        label: const Text(
                          'CONTINUAR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xff071B2B),
                          backgroundColor: const Color(0xff79E5B0),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Botón Salir
                      OutlinedButton.icon(
                        onPressed: onShowExit,
                        icon: const Icon(Icons.home_rounded, size: 22),
                        label: const Text(
                          'SALIR AL CAMPAMENTO BASE',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white70,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 300.ms, curve: Curves.easeOutCubic)
                .scale(
                  begin: const Offset(0.88, 0.88),
                  end: const Offset(1, 1),
                  curve: Curves.easeOutBack,
                  duration: 400.ms,
                ),
      ),
    );
  }
}
