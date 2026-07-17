import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Floating particle for parallax background effect
class FloatingParticle extends StatefulWidget {
  final double initialX;
  final double initialY;
  final double speed;
  final double size;
  final Color color;

  const FloatingParticle({
    super.key,
    required this.initialX,
    required this.initialY,
    required this.speed,
    required this.size,
    required this.color,
  });

  @override
  State<FloatingParticle> createState() => _FloatingParticleState();
}

class _FloatingParticleState extends State<FloatingParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: (8 / widget.speed).toInt().clamp(1, 20)),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final yOffset = _controller.value * 400; // Move up 400px over duration
        final xOffset = (math.sin(_controller.value * 2 * math.pi) * 30).toDouble(); // Sway horizontally
        final opacity = (math.sin(_controller.value * 2 * math.pi) * 0.3 + 0.4)
            .clamp(0, 1)
            .toDouble(); // Pulse opacity

        return Positioned(
          left: widget.initialX + xOffset,
          top: widget.initialY - yOffset,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.5),
                    blurRadius: widget.size / 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Animated forest-themed background with multiple gradient layers
class AnimatedForestBackground extends StatefulWidget {
  const AnimatedForestBackground({super.key});

  @override
  State<AnimatedForestBackground> createState() =>
      _AnimatedForestBackgroundState();
}

class _AnimatedForestBackgroundState extends State<AnimatedForestBackground>
    with TickerProviderStateMixin {
  late List<FloatingParticle> particles;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    final random = math.Random();

    // Generate 12 floating particles at different positions
    particles = List.generate(12, (index) {
      return FloatingParticle(
        initialX: random.nextDouble() * 400,
        initialY: random.nextDouble() * 600,
        speed: 0.5 + random.nextDouble() * 1.5,
        size: 2 + random.nextDouble() * 6,
        color: _particleColor(index),
      );
    });

    // Setup opacity animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _particleColor(int index) {
    final colors = [
      const Color(0xff79E5B0).withValues(alpha: 0.6),
      const Color(0xff4ADE80).withValues(alpha: 0.5),
      const Color(0xff22C55E).withValues(alpha: 0.4),
      Colors.white.withValues(alpha: 0.3),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff0B3954),
                Color(0xff071B2B),
              ],
            ),
          ),
        ),

        // Animated overlay gradient
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) => Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xff0F5A3B).withValues(alpha: 0.15),
                    const Color(0xff1B2845).withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Floating particles
        ...particles,

        // Radial glow effect
        ShaderMask(
          shaderCallback: (bounds) => RadialGradient(
            center: const Alignment(0, 0.2),
            radius: 1.2,
            colors: [
              const Color(0xff4ADE80).withValues(alpha: 0.05),
              Colors.transparent,
            ],
          ).createShader(bounds),
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, 0.2),
                radius: 1.2,
                colors: [
                  const Color(0xff4ADE80).withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
