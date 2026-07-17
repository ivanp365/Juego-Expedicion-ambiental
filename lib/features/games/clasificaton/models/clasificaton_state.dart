import 'waste_item.dart';

enum ClasificatonPhase { intro, levels, countdown, sorting, math, results }

enum LevelFlow { cover, playing, questions, finished }

/// Etapas del reto matemático
enum MathCardStage {
  hidden, // No hay tarjeta
  preview, // Se muestra la tarjeta completa
  question, // Se muestran las respuestas
  feedback, // Correcto / Incorrecto
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

  /// Nuevo estado de la tarjeta
  final MathCardStage mathStage;

  final WasteType? lastTarget;
  final bool? lastAnswerCorrect;

  const ClasificatonState({
    this.phase = ClasificatonPhase.intro,
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

      lastTarget: lastTarget ?? this.lastTarget,
      lastAnswerCorrect: lastAnswerCorrect ?? this.lastAnswerCorrect,
    );
  }
}
