import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/clasificaton_provider.dart';
import '../data/bins_repository.dart';
import '../models/clasificaton_state.dart';
import '../models/waste_item.dart';
import '../widgets/animated_background.dart';
import '../widgets/animated_stat_counter.dart';
import '../widgets/animated_xp_bar.dart';
import '../widgets/bin_target.dart';
import '../widgets/draggable_waste.dart';
import '../widgets/game_progress.dart';
import '../widgets/glassmorphic_hud.dart';
import '../widgets/professional_level_card.dart';
import '../widgets/safe_image.dart';

class ClasificatonPage extends ConsumerWidget {
  const ClasificatonPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(clasificatonProvider);
    final controller = ref.read(clasificatonProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xff071B2B),
      body: SafeArea(child: _buildPhase(context, game, controller)),
    );
  }

  Widget _buildPhase(
    BuildContext context,
    ClasificatonState game,
    ClasificatonController controller,
  ) {
    switch (game.phase) {
      case ClasificatonPhase.intro:
        return _IntroScreen(onStart: controller.showLevels);
      case ClasificatonPhase.levels:
        return _LevelSelectionScreen(onPlay: controller.startLevel);
      case ClasificatonPhase.countdown:
        return _CountdownScreen(onFinished: controller.startSorting);
      case ClasificatonPhase.sorting:
        return _SortingScreen(game: game, onDrop: controller.validateAnswer);
      case ClasificatonPhase.math:
        return _MathScreen(
          game: game,
          onReveal: controller.showQuestion,
          onAnswer: controller.answerMath,
        );
      case ClasificatonPhase.results:
        return _ResultsScreen(
          game: game,
          onReplay: controller.replay,
          onMenu: () {
            controller.reset();
            context.go('/base');
          },
        );
    }
  }
}

class _IntroScreen extends StatelessWidget {
  const _IntroScreen({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return _GameBackdrop(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SafeImage(
                    assetPath:
                        'assets/images/clasificaton/covers/portada_nivel_1.jpeg',
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms)
                .scale(curve: Curves.easeOutBack),
            const SizedBox(height: 28),
            const Text(
              'CLASIFICACIÓN',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.25),
            const SizedBox(height: 8),
            const Text(
              'Aprende a reciclar jugando',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xffB8D8E8),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            _PrimaryButton(
              label: 'COMENZAR',
              icon: Icons.play_arrow_rounded,
              onPressed: onStart,
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => context.go('/base'),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text(
                'REGRESAR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelSelectionScreen extends StatelessWidget {
  const _LevelSelectionScreen({required this.onPlay});

  final ValueChanged<int> onPlay;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Animated forest background with particles
        const AnimatedForestBackground(),

        // Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Header section
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'EXPEDICIÓN AMBIENTAL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.5),
                      const SizedBox(height: 8),
                      const Text(
                            'Elige tu misión para proteger el planeta',
                            style: TextStyle(
                              color: Color(0xffB8D8E8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                          .animate(delay: 150.ms)
                          .fadeIn(duration: 600.ms)
                          .slideX(begin: -0.5),
                    ],
                  ),
                ),

                // Level cards
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ProfessionalLevelCard(
                            level: 1,
                            imagePath:
                                'assets/images/clasificaton/covers/portada_nivel_1.jpeg',
                            subtitle: 'Primera expedición',
                            starsEarned: 0,
                            completionPercent: 0,
                            onPlay: onPlay,
                          )
                          .animate(delay: 300.ms)
                          .fadeIn(duration: 800.ms)
                          .slideY(begin: 0.3),
                      const SizedBox(height: 20),
                      ProfessionalLevelCard(
                            level: 2,
                            imagePath:
                                'assets/images/clasificaton/covers/portada_nivel_2.jpeg',
                            subtitle: 'Desafío experto',
                            starsEarned: 0,
                            completionPercent: 0,
                            isLocked: true,
                            onPlay: onPlay,
                          )
                          .animate(delay: 450.ms)
                          .fadeIn(duration: 800.ms)
                          .slideY(begin: 0.3),
                    ],
                  ),
                ),

                // Footer spacing
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CountdownScreen extends StatefulWidget {
  const _CountdownScreen({required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<_CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<_CountdownScreen> {
  int _count = 3;

  @override
  void initState() {
    super.initState();
    _runCountdown();
  }

  void _runCountdown() {
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (!mounted) {
        return;
      }

      if (_count == 0) {
        widget.onFinished();
        return;
      }

      setState(() => _count--);
      _runCountdown();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGo = _count == 0;

    return _GameBackdrop(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isGo ? '¡GO!' : '$_count',
              key: ValueKey(_count),
              style: TextStyle(
                color: isGo ? const Color(0xff79E5B0) : Colors.white,
                fontSize: 100,
                fontWeight: FontWeight.w900,
              ),
            ).animate().scale(
              begin: const Offset(0.2, 0.2),
              curve: Curves.elasticOut,
            ),
            const Text(
              'Prepárate para clasificar',
              style: TextStyle(color: Colors.white70, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortingScreen extends StatelessWidget {
  const _SortingScreen({required this.game, required this.onDrop});

  final ClasificatonState game;
  final ValueChanged<WasteType> onDrop;

  @override
  Widget build(BuildContext context) {
    final waste = game.currentWaste;

    if (waste == null) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xff79E5B0)),
      );
    }

    return _GameBackdrop(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final wasteSize = constraints.maxHeight < 650
              ? 130.0
              : isMobile
              ? 160.0
              : 200.0;

          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: Column(
              children: [
                // Professional Game HUD
                _GameHud(game: game),
                const SizedBox(height: 14),

                // Main gameplay area - waste object centered
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '✨ ARRASTRA AL CONTENEDOR CORRECTO',
                        style: TextStyle(
                          color: Color(0xffB8D8E8),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Draggable waste - center of attention
                      DraggableWaste(waste: waste, size: wasteSize),
                      const SizedBox(height: 8),
                      // Waste name
                      Text(
                        waste.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Bin targets - 4 always visible
                Expanded(
                  flex: 4,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: BinsRepository.bins.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isMobile ? 1.2 : 1.6,
                    ),
                    itemBuilder: (context, index) {
                      final bin = BinsRepository.bins[index];
                      return BinTarget(
                        bin: bin,
                        isLastTarget: game.lastTarget == bin.type,
                        lastAnswerCorrect: game.lastAnswerCorrect,
                        onAccept: (_) => onDrop(bin.type),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GameHud extends StatelessWidget {
  const _GameHud({required this.game});

  final ClasificatonState game;

  @override
  Widget build(BuildContext context) {
    return GlassmorphicHUD(
      padding: const EdgeInsets.all(16),
      blurAmount: 15,
      opacity: 0.12,
      child: Column(
        children: [
          // Top row: Score, Lives, Combo, Timer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Score counter
              AnimatedStatCounter(
                value: game.score,
                icon: '⭐',
                label: 'PUNTOS',
              ),
              // Lives indicator
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('❤️', style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 6),
                  Text(
                    game.lives.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'VIDAS',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Combo multiplier with pulsing effect
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 22))
                      .animate(
                        onPlay: (controller) {
                          if (game.combo > 1) {
                            controller.repeat();
                          }
                        },
                      )
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.2, 1.2),
                        duration: 600.ms,
                        curve: Curves.elasticInOut,
                      )
                      .fadeOut(duration: 300.ms),
                  const SizedBox(height: 6),
                  Text(
                    'x${game.combo}',
                    style: TextStyle(
                      color: game.combo > 5
                          ? const Color(0xffFFD166)
                          : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'COMBO',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Timer with gradient
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '⏱️',
                    style: TextStyle(
                      fontSize: 22,
                      color: game.secondsLeft < 30
                          ? const Color(0xffFFCDD2)
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${game.secondsLeft}s',
                    style: TextStyle(
                      color: game.secondsLeft < 30
                          ? const Color(0xffFFCDD2)
                          : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'TIEMPO',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Bottom section: Progress bar and level info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // EcoCoin counter
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💰 ECOMONEDAS',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      game.correct.toString(),
                      style: const TextStyle(
                        color: Color(0xffFFD166),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Progress bar
              Expanded(
                flex: 3,
                child: GameProgress(
                  current: game.currentIndex,
                  total: ClasificatonController.totalWastes,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // XP Bar
          AnimatedXPBar(
            progress: game.currentIndex / ClasificatonController.totalWastes,
            startColor: const Color(0xff79E5B0),
            endColor: const Color(0xff4ADE80),
            label: 'PROGRESO DE MISIÓN',
          ),
        ],
      ),
    );
  }
}

class _MathScreen extends StatelessWidget {
  const _MathScreen({
    required this.game,
    required this.onReveal,
    required this.onAnswer,
  });

  final ClasificatonState game;
  final VoidCallback onReveal;
  final ValueChanged<int> onAnswer;

  @override
  Widget build(BuildContext context) {
    final cardNumber = (game.mathIndex + 1).toString().padLeft(2, '0');
    final cardPath =
        'assets/images/clasificaton/cards/level${game.level}/level${game.level}_$cardNumber.jpeg';

    return _GameBackdrop(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'RETO MATEMÁTICO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '⭐ ${game.mathScore}  •  ⏱ ${game.secondsLeft}s',
                  style: const TextStyle(
                    color: Color(0xff79E5B0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${game.mathIndex + 1}/15',
                style: const TextStyle(
                  color: Color(0xffB8D8E8),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 11),
            Expanded(
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: switch (game.mathStage) {
                    MathCardStage.preview => _MathCard(
                      cardPath: cardPath,
                      onReveal: onReveal,
                    ),

                    MathCardStage.question => _MathQuestion(onAnswer: onAnswer),

                    MathCardStage.feedback => const Center(
                      child: CircularProgressIndicator(),
                    ),

                    _ => const SizedBox.shrink(),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MathCard extends StatelessWidget {
  const _MathCard({required this.cardPath, required this.onReveal});

  final String cardPath;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const ValueKey('math-card'),
      onTap: onReveal,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: SafeImage(assetPath: cardPath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onReveal,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text("Continuar"),
          ),
        ],
      ),
    ).animate().fadeIn().scale(
      begin: const Offset(0.92, 0.92),
      curve: Curves.easeOutBack,
    );
  }
}

class _MathQuestion extends StatelessWidget {
  const _MathQuestion({required this.onAnswer});

  final ValueChanged<int> onAnswer;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('math-question'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '¿Cuál es la respuesta correcta?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        for (var index = 0; index < 4; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OutlinedButton(
              onPressed: () => onAnswer(index),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xff79E5B0), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Opción ${String.fromCharCode(65 + index)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    ).animate().fadeIn().slideY(begin: 0.15);
  }
}

class _ResultsScreen extends StatelessWidget {
  const _ResultsScreen({
    required this.game,
    required this.onReplay,
    required this.onMenu,
  });

  final ClasificatonState game;
  final VoidCallback onReplay;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final stars = _starCount(game.totalScore);

    return _GameBackdrop(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            const Icon(
              Icons.workspace_premium_rounded,
              size: 80,
              color: Color(0xffFFD166),
            ),
            const Text(
              '¡MISIÓN COMPLETADA!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ).animate().fadeIn().scale(),
            const SizedBox(height: 10),
            Text(
              'Nivel ${game.level}  ${'★' * stars}${'☆' * (3 - stars)}',
              style: const TextStyle(color: Color(0xffFFD166), fontSize: 25),
            ),
            const SizedBox(height: 24),
            _ResultsSummary(game: game),
            const SizedBox(height: 14),
            const Text(
              'Insignia: Guardián del Reciclaje',
              style: TextStyle(
                color: Color(0xff79E5B0),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            _PrimaryButton(
              label: 'VOLVER A JUGAR',
              icon: Icons.replay_rounded,
              onPressed: onReplay,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onMenu,
              child: const Text(
                'MENÚ PRINCIPAL',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _starCount(int score) {
    if (score >= 500) {
      return 3;
    }

    if (score >= 280) {
      return 2;
    }

    return 1;
  }
}

class _ResultsSummary extends StatelessWidget {
  const _ResultsSummary({required this.game});

  final ClasificatonState game;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          _ResultRow(label: 'Clasificación', value: '${game.score} pts'),
          _ResultRow(label: 'Matemáticas', value: '${game.mathScore} pts'),
          _ResultRow(label: 'Tiempo restante', value: '${game.secondsLeft}s'),
          _ResultRow(
            label: 'Precisión',
            value: '${(game.accuracy * 100).round()}%',
          ),
          _ResultRow(label: 'Errores', value: '${game.incorrect}'),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {
        HapticFeedback.selectionClick();
        onPressed();
      },
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(58),
        backgroundColor: const Color(0xff22B573),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      icon: Icon(icon),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.8),
      ),
    );
  }
}

class _GameBackdrop extends StatelessWidget {
  const _GameBackdrop({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff0B3954), Color(0xff071B2B)],
        ),
      ),
      child: child,
    );
  }
}
