import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Fondo animado de bosque mágico con luciérnagas y niebla.
/// Ideal para pantallas de juego y home.
class ForestBackground extends StatefulWidget {
  const ForestBackground({super.key});

  @override
  State<ForestBackground> createState() => _ForestBackgroundState();
}

class _ForestBackgroundState extends State<ForestBackground>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _fogController;
  late final AnimationController _pulseController;

  final List<Firefly> _fireflies = List.generate(25, (_) => Firefly.random());
  final List<FogParticle> _fogParticles = List.generate(
    5,
    (_) => FogParticle.random(),
  );

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _fogController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _fogController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _mainController,
        _fogController,
        _pulseController,
      ]),
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0D2B1D),
                Color(0xFF1A4D2E),
                Color(0xFF0F3D2A),
                Color(0xFF0D2B1D),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // ─── Capa de niebla ───
              ..._fogParticles.map(
                (fog) => Positioned(
                  left:
                      fog.x +
                      math.sin(
                            _fogController.value * 2 * math.pi * fog.speed +
                                fog.offset,
                          ) *
                          80,
                  top: fog.y,
                  child: Container(
                    width: fog.width,
                    height: fog.height,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.04),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ─── Rayos de luz filtrándose entre árboles ───
              Positioned(
                top: -50,
                left: MediaQuery.of(context).size.width * 0.2,
                child: Transform.rotate(
                  angle: -0.3,
                  child: Container(
                    width: 120,
                    height: 400,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF95D5B2).withValues(alpha: 0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: -30,
                right: MediaQuery.of(context).size.width * 0.15,
                child: Transform.rotate(
                  angle: 0.25,
                  child: Container(
                    width: 100,
                    height: 350,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFE9C46A).withValues(alpha: 0.06),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ─── Luciérnagas animadas ───
              ..._fireflies.map((firefly) {
                final time = _mainController.value;
                final pulse = _pulseController.value;

                final orbitX =
                    math.sin(
                      time * 2 * math.pi * firefly.speed + firefly.offset,
                    ) *
                    firefly.orbitRadius;
                final orbitY =
                    math.cos(
                      time * 2 * math.pi * firefly.speed * 0.7 + firefly.offset,
                    ) *
                    firefly.orbitRadius *
                    0.6;

                final brightness =
                    0.4 +
                    (math.sin(
                              time * 2 * math.pi * firefly.blinkSpeed +
                                  firefly.offset,
                            ) +
                            1) *
                        0.3 +
                    pulse * 0.1;

                return Positioned(
                  left: firefly.baseX + orbitX,
                  top: firefly.baseY + orbitY,
                  child: Container(
                    width: firefly.size,
                    height: firefly.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: firefly.color.withValues(
                        alpha: brightness.clamp(0.1, 1.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: firefly.color.withValues(
                            alpha: brightness * 0.6,
                          ),
                          blurRadius: firefly.size * 2,
                          spreadRadius: firefly.size * 0.5,
                        ),
                        BoxShadow(
                          color: firefly.color.withValues(
                            alpha: brightness * 0.3,
                          ),
                          blurRadius: firefly.size * 4,
                          spreadRadius: firefly.size,
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // ─── Bokeh sutil en el fondo ───
              Positioned(
                bottom: 100,
                left: 50,
                child: _buildBokeh(80, const Color(0xFF52B788), 0.05),
              ),
              Positioned(
                top: 150,
                right: 80,
                child: _buildBokeh(60, const Color(0xFFD4A373), 0.04),
              ),
              Positioned(
                bottom: 200,
                right: 120,
                child: _buildBokeh(100, const Color(0xFF95D5B2), 0.03),
              ),

              // ─── Viñeta oscura en bordes ───
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.2,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBokeh(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MODELOS DE PARTÍCULAS
// ═══════════════════════════════════════════════════════════════

class Firefly {
  final double baseX;
  final double baseY;
  final double size;
  final double speed;
  final double blinkSpeed;
  final double orbitRadius;
  final double offset;
  final Color color;

  Firefly({
    required this.baseX,
    required this.baseY,
    required this.size,
    required this.speed,
    required this.blinkSpeed,
    required this.orbitRadius,
    required this.offset,
    required this.color,
  });

  factory Firefly.random() {
    final random = math.Random();
    return Firefly(
      baseX: random.nextDouble() * 400,
      baseY: random.nextDouble() * 800,
      size: 2 + random.nextDouble() * 4,
      speed: 0.3 + random.nextDouble() * 0.7,
      blinkSpeed: 0.5 + random.nextDouble() * 1.5,
      orbitRadius: 20 + random.nextDouble() * 60,
      offset: random.nextDouble() * 2 * math.pi,
      color: random.nextBool()
          ? const Color(0xFF95D5B2)
          : (random.nextBool()
                ? const Color(0xFFE9C46A)
                : const Color(0xFF74C69D)),
    );
  }
}

class FogParticle {
  final double x;
  final double y;
  final double width;
  final double height;
  final double speed;
  final double offset;

  FogParticle({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.speed,
    required this.offset,
  });

  factory FogParticle.random() {
    final random = math.Random();
    return FogParticle(
      x: random.nextDouble() * 300,
      y: random.nextDouble() * 600,
      width: 150 + random.nextDouble() * 250,
      height: 80 + random.nextDouble() * 120,
      speed: 0.1 + random.nextDouble() * 0.3,
      offset: random.nextDouble() * 2 * math.pi,
    );
  }
}
