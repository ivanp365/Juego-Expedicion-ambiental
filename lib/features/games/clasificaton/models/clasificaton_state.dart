import 'waste_item.dart';

enum ClasificatonPhase {
  intro,
  levels,
  cover,
  countdown,
  sorting,
  math,
  results,
}

enum LevelFlow { cover, playing, questions, finished }

/// Etapas del reto matemático
enum MathCardStage { hidden, preview, question, feedback }

// ═══════════════════════════════════════════════════════════════════════════
// NUEVO: Estados del sistema de pausa
// ═══════════════════════════════════════════════════════════════════════════
enum PauseState {
  none, // Juego activo, sin menús
  paused, // Menú de pausa visible
  exitConfirmation, // Diálogo de confirmación de salida
}

class ClasificatonState {
  final ClasificatonPhase phase;
  final LevelFlow levelFlow;
  final WasteItem? currentWaste;

  final int level;

  final int score;
  final int mathScore;

  final int correct;
  final int incorrect;

  final int lives;
  final int combo;

  final int currentIndex;

  final int secondsLeft;

  final int mathIndex;
  final int mathCorrect;

  final MathCardStage mathStage;

  final int? selectedAnswerIndex;
  final bool? isAnswerCorrect;

  // ═══════════════════════════════════════════════════════════════════════
  // NUEVO: Estado de pausa (reemplaza isPaused + showExitConfirmation)
  // ═══════════════════════════════════════════════════════════════════════
  final PauseState pauseState;

  final WasteType? lastTarget;
  final bool? lastAnswerCorrect;

  const ClasificatonState({
    this.phase = ClasificatonPhase.levels,
    this.levelFlow = LevelFlow.cover,
    this.currentWaste,

    this.level = 1,

    this.score = 0,
    this.mathScore = 0,

    this.correct = 0,
    this.incorrect = 0,

    this.lives = 3,
    this.combo = 0,

    this.currentIndex = 0,

    this.secondsLeft = 120,

    this.mathIndex = 0,
    this.mathCorrect = 0,

    this.mathStage = MathCardStage.preview,

    this.selectedAnswerIndex,
    this.isAnswerCorrect,

    // Nuevo campo con default
    this.pauseState = PauseState.none,

    this.lastTarget,
    this.lastAnswerCorrect,
  });

  int get totalScore => score + mathScore;

  double get accuracy => currentIndex == 0 ? 0 : correct / currentIndex;

  ClasificatonState copyWith({
    ClasificatonPhase? phase,
    LevelFlow? levelFlow,
    WasteItem? currentWaste,

    int? level,

    int? score,
    int? mathScore,

    int? correct,
    int? incorrect,

    int? lives,
    int? combo,

    int? currentIndex,

    int? secondsLeft,

    int? mathIndex,
    int? mathCorrect,

    MathCardStage? mathStage,

    int? selectedAnswerIndex,
    bool? isAnswerCorrect,

    // Nuevo campo en copyWith
    PauseState? pauseState,

    WasteType? lastTarget,
    bool? lastAnswerCorrect,
  }) {
    return ClasificatonState(
      phase: phase ?? this.phase,
      levelFlow: levelFlow ?? this.levelFlow,
      currentWaste: currentWaste ?? this.currentWaste,

      level: level ?? this.level,

      score: score ?? this.score,
      mathScore: mathScore ?? this.mathScore,

      correct: correct ?? this.correct,
      incorrect: incorrect ?? this.incorrect,

      lives: lives ?? this.lives,
      combo: combo ?? this.combo,

      currentIndex: currentIndex ?? this.currentIndex,

      secondsLeft: secondsLeft ?? this.secondsLeft,

      mathIndex: mathIndex ?? this.mathIndex,
      mathCorrect: mathCorrect ?? this.mathCorrect,

      mathStage: mathStage ?? this.mathStage,

      selectedAnswerIndex: selectedAnswerIndex,
      isAnswerCorrect: isAnswerCorrect,

      // Pasar nuevo campo
      pauseState: pauseState ?? this.pauseState,

      lastTarget: lastTarget ?? this.lastTarget,
      lastAnswerCorrect: lastAnswerCorrect ?? this.lastAnswerCorrect,
    );
  }
}
