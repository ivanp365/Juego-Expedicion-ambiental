import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../application/clasificaton_provider.dart';
import '../models/clasificaton_state.dart';
import 'animated_stat_counter.dart';
import 'animated_xp_bar.dart';

/// Professional Material 3 in-game HUD with comprehensive stat display
class ProfessionalGameHUD extends StatelessWidget {
  final ClasificatonState game;

  const ProfessionalGameHUD({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final urgentTimer = game.secondsLeft < 30;
    final highCombo = game.combo > 5;

    return Column(
      children: [
        // Main HUD container with Material 3 styling
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.04),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              // Row 1: Score, Lives, Combo, Timer
              _buildTopMetricsRow(context, urgentTimer, highCombo),
              const SizedBox(height: 14),

              // Row 2: XP Bar (full width)
              SizedBox(
                width: double.infinity,
                child: AnimatedXPBar(
                  progress:
                      game.currentIndex / ClasificatonController.totalWastes,
                  startColor: const Color(0xff79E5B0),
                  endColor: const Color(0xff4ADE80),
                  label: 'PROGRESO DE MISIÓN',
                ).animate().fadeIn(duration: 600.ms),
              ),
              const SizedBox(height: 12),

              // Row 3: EcoCoins and Remaining Waste
              _buildSecondaryMetricsRow(context),
              const SizedBox(height: 12),

              // Row 4: Progress indicator with percentage
              _buildProgressIndicator(context),
            ],
          ),
        ).animate().fadeIn(duration: 700.ms).slideY(begin: -0.3),
      ],
    );
  }

  Widget _buildTopMetricsRow(
    BuildContext context,
    bool urgentTimer,
    bool highCombo,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Score
        _MetricCard(
          icon: '⭐',
          label: 'PUNTOS',
          child: AnimatedStatCounter(
            value: game.score,
            icon: '⭐',
            label: 'PUNTOS',
          ),
        ),

        // Lives
        _MetricCard(
          icon: '❤️',
          label: 'VIDAS',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                game.lives.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),

        // Combo with pulsing effect
        _MetricCard(
          icon: '🔥',
          label: 'COMBO',
          accentColor: highCombo ? const Color(0xffFFD166) : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                    'x${game.combo}',
                    style: TextStyle(
                      color: highCombo ? const Color(0xffFFD166) : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                  .animate(
                    onPlay: (controller) {
                      if (game.combo > 1) {
                        controller.repeat();
                      }
                    },
                  )
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.15, 1.15),
                    duration: 600.ms,
                    curve: Curves.elasticInOut,
                  ),
            ],
          ),
        ),

        // Timer
        _MetricCard(
          icon: '⏱️',
          label: 'TIEMPO',
          accentColor: urgentTimer ? const Color(0xffFF6B6B) : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${game.secondsLeft}s',
                style: TextStyle(
                  color: urgentTimer ? const Color(0xffFF6B6B) : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryMetricsRow(BuildContext context) {
    return Row(
      children: [
        // EcoCoins
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  const Color(0xffFFD166).withValues(alpha: 0.12),
                  const Color(0xffFFC93C).withValues(alpha: 0.08),
                ],
              ),
              border: Border.all(
                color: const Color(0xffFFD166).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '💰 ECOMONEDAS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  game.correct.toString(),
                  style: const TextStyle(
                    color: Color(0xffFFD166),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ).animate().fadeIn().scale(
                  begin: const Offset(0.8, 0.8),
                  curve: Curves.elasticOut,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Remaining Waste Count
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  const Color(0xff79E5B0).withValues(alpha: 0.12),
                  const Color(0xff4ADE80).withValues(alpha: 0.08),
                ],
              ),
              border: Border.all(
                color: const Color(0xff79E5B0).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📦 RESIDUOS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${game.currentIndex}/${ClasificatonController.totalWastes}',
                  style: const TextStyle(
                    color: Color(0xff79E5B0),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ).animate().fadeIn().scale(
                  begin: const Offset(0.8, 0.8),
                  curve: Curves.elasticOut,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Current Stats
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  const Color(0xff64B5F6).withValues(alpha: 0.12),
                  const Color(0xff42A5F5).withValues(alpha: 0.08),
                ],
              ),
              border: Border.all(
                color: const Color(0xff64B5F6).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '✓ CORRECTAS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${game.correct}/${game.currentIndex}',
                  style: const TextStyle(
                    color: Color(0xff64B5F6),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ).animate().fadeIn().scale(
                  begin: const Offset(0.8, 0.8),
                  curve: Curves.elasticOut,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final accuracy = game.currentIndex == 0
        ? 0
        : (game.correct / game.currentIndex * 100).toInt();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.04),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PROGRESO GENERAL',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                '${(game.currentIndex / ClasificatonController.totalWastes * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Color(0xff79E5B0),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: game.currentIndex / ClasificatonController.totalWastes,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                game.currentIndex / ClasificatonController.totalWastes >= 1.0
                    ? const Color(0xff22C55E)
                    : const Color(0xff79E5B0),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Precisión: $accuracy%',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Errores: ${game.incorrect}',
                style: TextStyle(
                  color: game.incorrect > 2
                      ? const Color(0xffFF6B6B).withValues(alpha: 0.8)
                      : Colors.white.withValues(alpha: 0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual metric card with icon and styling
class _MetricCard extends StatelessWidget {
  final String icon;
  final String label;
  final Widget child;
  final Color? accentColor;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.child,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: accentColor != null
                ? [
                    accentColor!.withValues(alpha: 0.15),
                    accentColor!.withValues(alpha: 0.08),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.04),
                  ],
          ),
          border: Border.all(
            color:
                accentColor?.withValues(alpha: 0.3) ??
                Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            child,
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
