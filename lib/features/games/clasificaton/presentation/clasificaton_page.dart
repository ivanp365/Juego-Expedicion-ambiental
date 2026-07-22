import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../player/application/player_provider.dart';
import '../application/clasificaton_provider.dart';
import '../data/bins_repository.dart';
import '../data/math_questions_repository.dart';
import '../models/clasificaton_state.dart';
import '../models/waste_item.dart';
import '../widgets/animated_background.dart';
import '../widgets/animated_xp_bar.dart';
import '../widgets/bin_target.dart';
import '../widgets/draggable_waste.dart';
import '../widgets/glassmorphic_hud.dart';
import '../widgets/pause_menu.dart';
import '../widgets/exit_confirmation_dialog.dart';
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
      body: SafeArea(
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;

            final isPlaying =
                game.phase == ClasificatonPhase.cover ||
                game.phase == ClasificatonPhase.countdown ||
                game.phase == ClasificatonPhase.sorting ||
                game.phase == ClasificatonPhase.math ||
                game.phase == ClasificatonPhase.results;

            if (!isPlaying) {
              context.go('/base');
              return;
            }

            switch (game.pauseState) {
              case PauseState.none:
                controller.pauseGame();
                break;
              case PauseState.paused:
                controller.showExitConfirmation();
                break;
              case PauseState.exitConfirmation:
                controller.hideExitConfirmation();
                break;
            }
          },
          child: _buildPhase(context, game, controller),
        ),
      ),
    );
  }

  Widget _buildPhase(
    BuildContext context,
    ClasificatonState game,
    ClasificatonController controller,
  ) {
    final pauseCallbacks = _PauseCallbacks(
      pauseState: game.pauseState,
      onPause: controller.pauseGame,
      onResume: controller.resumeGame,
      onShowExit: controller.showExitConfirmation,
      onHideExit: controller.hideExitConfirmation,
      onConfirmExit: () {
        controller.confirmExit();
        context.go('/base');
      },
      onAwardCompletion: controller.awardCompletion,
    );

    switch (game.phase) {
      case ClasificatonPhase.intro:
        controller.showLevels();
        return const SizedBox.shrink();
      case ClasificatonPhase.levels:
        return _LevelSelectionScreen(onPlay: controller.startLevel);
      case ClasificatonPhase.cover:
        return _LevelCoverScreen(
          level: game.level,
          onStart: controller.startCountdown,
          pauseCallbacks: pauseCallbacks,
        );
      case ClasificatonPhase.countdown:
        return _CountdownScreen(
          onFinished: controller.startSorting,
          pauseCallbacks: pauseCallbacks,
        );
      case ClasificatonPhase.sorting:
        return _SortingScreen(
          game: game,
          onDrop: controller.validateAnswer,
          pauseCallbacks: pauseCallbacks,
        );
      case ClasificatonPhase.math:
        return _MathScreen(
          game: game,
          onReveal: controller.showQuestion,
          onPreview: controller.showPreview,
          onAnswer: controller.answerMath,
          pauseCallbacks: pauseCallbacks,
        );
      case ClasificatonPhase.results:
        return _ResultsScreen(
          game: game,
          onReplay: controller.replay,
          onMenu: () {
            controller.reset();
            context.go('/base');
          },
          pauseCallbacks: pauseCallbacks,
        );
    }
  }
}

class _PauseCallbacks {
  const _PauseCallbacks({
    required this.pauseState,
    required this.onPause,
    required this.onResume,
    required this.onShowExit,
    required this.onHideExit,
    required this.onConfirmExit,
    this.onAwardCompletion,
  });

  final PauseState pauseState;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onShowExit;
  final VoidCallback onHideExit;
  final VoidCallback onConfirmExit;
  final VoidCallback? onAwardCompletion;
}

class _LevelSelectionScreen extends ConsumerWidget {
  const _LevelSelectionScreen({required this.onPlay});

  final ValueChanged<int> onPlay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);

    return Stack(
      fit: StackFit.expand,
      children: [
        const ForestBackground(),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
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
                            isLocked: !player.isLevelUnlocked(
                              'clasificaton',
                              1,
                            ),
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
                            isLocked: !player.isLevelUnlocked(
                              'clasificaton',
                              2,
                            ),
                            onPlay: onPlay,
                          )
                          .animate(delay: 450.ms)
                          .fadeIn(duration: 800.ms)
                          .slideY(begin: 0.3),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LevelCoverScreen extends StatelessWidget {
  const _LevelCoverScreen({
    required this.level,
    required this.onStart,
    required this.pauseCallbacks,
  });

  final int level;
  final VoidCallback onStart;
  final _PauseCallbacks pauseCallbacks;

  @override
  Widget build(BuildContext context) {
    final cardPath =
        'assets/images/clasificaton/covers/portada_nivel_$level.jpeg';

    return _GameBackdrop(
      pauseState: pauseCallbacks.pauseState,
      onResume: pauseCallbacks.onResume,
      onShowExit: pauseCallbacks.onShowExit,
      onHideExit: pauseCallbacks.onHideExit,
      onConfirmExit: pauseCallbacks.onConfirmExit,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              Expanded(
                // ← agregar
                flex: 3, // ← agregar
                child:
                    ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(cardPath, fit: BoxFit.contain),
                        )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .scale(curve: Curves.easeOutBack),
              ), // ← cerrar Expanded
              const SizedBox(height: 20),
              Text(
                'NIVEL $level',

                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.25),
              const SizedBox(height: 6),
              const Text(
                '¡Prepara tu mente para el reto!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xffB8D8E8),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(flex: 2),
              _PrimaryButton(
                label: 'COMENZAR',
                icon: Icons.play_arrow_rounded,
                onPressed: onStart,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountdownScreen extends StatefulWidget {
  const _CountdownScreen({
    required this.onFinished,
    required this.pauseCallbacks,
  });

  final VoidCallback onFinished;
  final _PauseCallbacks pauseCallbacks;

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
      if (!mounted) return;
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
      pauseState: widget.pauseCallbacks.pauseState,
      onResume: widget.pauseCallbacks.onResume,
      onShowExit: widget.pauseCallbacks.onShowExit,
      onHideExit: widget.pauseCallbacks.onHideExit,
      onConfirmExit: widget.pauseCallbacks.onConfirmExit,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),
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
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortingScreen extends StatelessWidget {
  const _SortingScreen({
    required this.game,
    required this.onDrop,
    required this.pauseCallbacks,
  });

  final ClasificatonState game;
  final ValueChanged<WasteType> onDrop;
  final _PauseCallbacks pauseCallbacks;

  @override
  Widget build(BuildContext context) {
    final waste = game.currentWaste;

    if (waste == null) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xff79E5B0)),
      );
    }

    return _GameBackdrop(
      pauseState: pauseCallbacks.pauseState,
      onResume: pauseCallbacks.onResume,
      onShowExit: pauseCallbacks.onShowExit,
      onHideExit: pauseCallbacks.onHideExit,
      onConfirmExit: pauseCallbacks.onConfirmExit,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final wasteSize = constraints.maxHeight < 650
              ? 90.0
              : isMobile
              ? 120.0
              : 160.0;

          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Column(
              children: [
                SizedBox(
                  height: isMobile ? 100 : 120,
                  child: _GameHud(game: game),
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '✨ ARRASTRA AL CONTENEDOR CORRECTO',
                        style: TextStyle(
                          color: Color(0xffB8D8E8),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      DraggableWaste(waste: waste, size: wasteSize),
                      const SizedBox(height: 2),
                      Text(
                        waste.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 2,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: BinsRepository.bins.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: isMobile ? 1.25 : 1.4,
                    ),
                    itemBuilder: (context, index) {
                      final bin = BinsRepository.bins[index];
                      return BinTarget(
                        bin: bin,
                        isLastTarget: game.lastTarget == bin.type,
                        lastAnswerCorrect: game.lastAnswerCorrect,
                        onAccept: game.pauseState != PauseState.none
                            ? (_) {}
                            : (_) => onDrop(bin.type),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      blurAmount: 15,
      opacity: 0.12,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CompactStat(icon: '⭐', value: game.score, label: 'PUNTOS'),
              _CompactStat(icon: '❤️', value: game.lives, label: 'VIDAS'),
              _CompactStat(
                icon: '🔥',
                value: game.combo,
                label: 'COMBO',
                highlight: game.combo > 5,
              ),
              _CompactStat(
                icon: '⏱️',
                value: game.secondsLeft,
                label: 'TIEMPO',
                alert: game.secondsLeft < 30,
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedXPBar(
            progress: game.currentIndex / ClasificatonController.totalWastes,
            startColor: const Color(0xff79E5B0),
            endColor: const Color(0xff4ADE80),
            label: 'PROGRESO DE MISIÓN',
            compact: true,
          ),
        ],
      ),
    );
  }
}

class _CompactStat extends StatelessWidget {
  const _CompactStat({
    required this.icon,
    required this.value,
    required this.label,
    this.highlight = false,
    this.alert = false,
  });

  final String icon;
  final int value;
  final String label;
  final bool highlight;
  final bool alert;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          icon,
          style: TextStyle(
            fontSize: 18,
            color: alert ? const Color(0xffFFCDD2) : null,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$value',
          style: TextStyle(
            color: alert
                ? const Color(0xffFFCDD2)
                : highlight
                ? const Color(0xffFFD166)
                : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MathScreen extends StatelessWidget {
  const _MathScreen({
    required this.game,
    required this.onReveal,
    required this.onPreview,
    required this.onAnswer,
    required this.pauseCallbacks,
  });

  final ClasificatonState game;
  final VoidCallback onReveal;
  final VoidCallback onPreview;
  final ValueChanged<int> onAnswer;
  final _PauseCallbacks pauseCallbacks;

  @override
  Widget build(BuildContext context) {
    final cardNumber = (game.mathIndex + 1).toString().padLeft(2, '0');
    final cardPath =
        'assets/images/clasificaton/cards/level${game.level}/level${game.level}_$cardNumber.jpeg';

    final question = game.level == 1
        ? MathQuestionsRepository.level1[game.mathIndex]
        : MathQuestionsRepository.level2[game.mathIndex];

    final isPausado = game.pauseState != PauseState.none;

    return _GameBackdrop(
      pauseState: pauseCallbacks.pauseState,
      onResume: pauseCallbacks.onResume,
      onShowExit: pauseCallbacks.onShowExit,
      onHideExit: pauseCallbacks.onHideExit,
      onConfirmExit: pauseCallbacks.onConfirmExit,
      child: SafeArea(
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
                        onReveal: isPausado ? () {} : onReveal,
                      ),
                      MathCardStage.question => _MathQuestion(
                        question: question,
                        onAnswer: onAnswer,
                        onBack: onPreview,
                        isPaused: isPausado,
                      ),
                      MathCardStage.feedback => _MathQuestion(
                        question: question,
                        onAnswer: onAnswer,
                        onBack: onPreview,
                        selectedIndex: game.selectedAnswerIndex,
                        isCorrect: game.isAnswerCorrect,
                        correctIndex: question.correctIndex,
                        showFeedback: true,
                      ),
                      MathCardStage.hidden => const SizedBox.shrink(),
                    },
                  ),
                ),
              ),
            ],
          ),
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
  const _MathQuestion({
    required this.question,
    required this.onAnswer,
    required this.onBack,
    this.selectedIndex,
    this.isCorrect,
    this.correctIndex,
    this.showFeedback = false,
    this.isPaused = false,
  });

  final MathQuestion question;
  final ValueChanged<int> onAnswer;
  final VoidCallback onBack;
  final int? selectedIndex;
  final bool? isCorrect;
  final int? correctIndex;
  final bool showFeedback;
  final bool isPaused;

  Color _optionBackground(int index) {
    if (!showFeedback) return Colors.transparent;
    if (index == correctIndex) {
      return const Color(0xff22C55E).withValues(alpha: 0.2);
    }
    if (index == selectedIndex && !(isCorrect ?? false)) {
      return const Color(0xffEF4444).withValues(alpha: 0.2);
    }
    return Colors.transparent;
  }

  Color _optionBorderColor(int index) {
    if (!showFeedback) return const Color(0xff79E5B0);
    if (index == correctIndex) return const Color(0xff22C55E);
    if (index == selectedIndex && !(isCorrect ?? false)) {
      return const Color(0xffEF4444);
    }
    return const Color(0xff79E5B0).withValues(alpha: 0.3);
  }

  Widget _feedbackIcon(int index) {
    if (!showFeedback) return const SizedBox.shrink();
    if (index == correctIndex) {
      return const Icon(
        Icons.check_circle_rounded,
        color: Color(0xff22C55E),
        size: 28,
      ).animate().scale(
        begin: const Offset(0, 0),
        end: const Offset(1, 1),
        curve: Curves.elasticOut,
        duration: 400.ms,
      );
    }
    if (index == selectedIndex && !(isCorrect ?? false)) {
      return const Icon(
        Icons.cancel_rounded,
        color: Color(0xffEF4444),
        size: 28,
      ).animate().scale(
        begin: const Offset(0, 0),
        end: const Offset(1, 1),
        curve: Curves.elasticOut,
        duration: 400.ms,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _animateOption(Widget child, int index) {
    if (!showFeedback) return child;
    if (index == correctIndex) {
      return child
          .animate()
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.04, 1.04),
            curve: Curves.easeOutBack,
            duration: 300.ms,
          )
          .then()
          .scale(
            begin: const Offset(1.04, 1.04),
            end: const Offset(1, 1),
            duration: 200.ms,
          );
    }
    if (index == selectedIndex && !(isCorrect ?? false)) {
      return child.animate().shake(
        hz: 5,
        offset: const Offset(8, 0),
        duration: 500.ms,
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('math-question'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!showFeedback)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white70),
              label: const Text(
                "Ver tarjeta",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        const SizedBox(height: 16),
        if (showFeedback) ...[
          Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: (isCorrect ?? false)
                        ? const Color(0xff22C55E).withValues(alpha: 0.15)
                        : const Color(0xffEF4444).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (isCorrect ?? false)
                          ? const Color(0xff22C55E).withValues(alpha: 0.4)
                          : const Color(0xffEF4444).withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    (isCorrect ?? false)
                        ? '¡Correcto!'
                        : 'Respuesta incorrecta',
                    style: TextStyle(
                      color: (isCorrect ?? false)
                          ? const Color(0xff86EFAC)
                          : const Color(0xffFCA5A5),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: -0.3, curve: Curves.easeOutCubic),
          const SizedBox(height: 20),
        ],
        const Text(
          "Selecciona la respuesta correcta",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        for (var index = 0; index < question.options.length; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _animateOption(
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: _optionBackground(index),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _optionBorderColor(index),
                    width:
                        showFeedback &&
                            (index == correctIndex || index == selectedIndex)
                        ? 2.5
                        : 2,
                  ),
                  boxShadow: showFeedback && index == correctIndex
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xff22C55E,
                            ).withValues(alpha: 0.3),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (showFeedback || isPaused)
                        ? null
                        : () => onAnswer(index),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: showFeedback && index == correctIndex
                                  ? const Color(
                                      0xff22C55E,
                                    ).withValues(alpha: 0.2)
                                  : Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: showFeedback && index == correctIndex
                                    ? const Color(0xff22C55E)
                                    : Colors.white.withValues(alpha: 0.15),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: TextStyle(
                                  color: showFeedback && index == correctIndex
                                      ? const Color(0xff86EFAC)
                                      : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              question.options[index],
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _feedbackIcon(index),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              index,
            ),
          ),
      ],
    ).animate().fadeIn().slideY(begin: 0.15);
  }
}

class _ResultsScreen extends ConsumerWidget {
  const _ResultsScreen({
    required this.game,
    required this.onReplay,
    required this.onMenu,
    required this.pauseCallbacks,
  });

  final ClasificatonState game;
  final VoidCallback onReplay;
  final VoidCallback onMenu;
  final _PauseCallbacks pauseCallbacks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stars = _starCount(game.totalScore);
    final player = ref.watch(playerProvider);

    return _GameBackdrop(
      pauseState: pauseCallbacks.pauseState,
      onResume: pauseCallbacks.onResume,
      onShowExit: pauseCallbacks.onShowExit,
      onHideExit: pauseCallbacks.onHideExit,
      onConfirmExit: pauseCallbacks.onConfirmExit,
      child: SafeArea(
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
              // ═════════════════════════════════════════════════════════════
              // NUEVO: Mostrar recompensas ganadas
              // ═════════════════════════════════════════════════════════════
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff79E5B0).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xff79E5B0).withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'RECOMPENSAS',
                      style: TextStyle(
                        color: const Color(0xff79E5B0),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _RewardItem(
                          icon: '⭐',
                          value:
                              '+${game.correct * 10 + game.mathCorrect * 25 + 100}',
                          label: 'XP',
                        ),
                        _RewardItem(
                          icon: '🪙',
                          value: '+${game.correct * 2 + 10}',
                          label: 'ECOCOINS',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Nivel Ambiental: ${player.level}  •  XP: ${player.xp}/100',
                style: const TextStyle(
                  color: Color(0xffB8D8E8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _PrimaryButton(
                label: 'RECOGER RECOMPENSAS',
                icon: Icons.redeem_rounded,
                onPressed: () {
                  pauseCallbacks.onAwardCompletion?.call();
                  onReplay();
                },
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
      ),
    );
  }

  int _starCount(int score) {
    if (score >= 500) return 3;
    if (score >= 280) return 2;
    return 1;
  }
}

class _RewardItem extends StatelessWidget {
  const _RewardItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final String icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xffB8D8E8),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
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
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xff071B2B),
        backgroundColor: const Color(0xff79E5B0),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
    );
  }
}

class _GameBackdrop extends StatelessWidget {
  const _GameBackdrop({
    required this.child,
    this.pauseState = PauseState.none,
    this.onResume,
    this.onShowExit,
    this.onHideExit,
    this.onConfirmExit,
  });

  final Widget child;
  final PauseState pauseState;
  final VoidCallback? onResume;
  final VoidCallback? onShowExit;
  final VoidCallback? onHideExit;
  final VoidCallback? onConfirmExit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'images/backgrounds/forest_game.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Container(color: const Color(0xff071B2B)),
        ),
        Container(color: Colors.black.withValues(alpha: 0.25)),
        child,
        if (pauseState != PauseState.none)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),
        if (pauseState == PauseState.paused)
          PauseMenuOverlay(onResume: onResume!, onShowExit: onShowExit!),
        if (pauseState == PauseState.exitConfirmation)
          ExitConfirmationDialog(
            onCancel: onHideExit!,
            onConfirm: onConfirmExit!,
          ),
      ],
    );
  }
}
