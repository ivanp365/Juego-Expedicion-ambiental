import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Glassmorphism HUD container with frosted glass effect for game UI
class GlassmorphicHUD extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double blurAmount;
  final double opacity;

  const GlassmorphicHUD({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.blurAmount = 12,
    this.opacity = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: opacity * 1.2),
                Colors.white.withValues(alpha: opacity * 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 24,
                spreadRadius: 1,
              ),
            ],
          ),
          child: child,
        ).animate().fadeIn(duration: 400.ms).scale(
              begin: const Offset(0.95, 0.95),
              curve: Curves.easeOutBack,
            ),
      ),
    );
  }
}
