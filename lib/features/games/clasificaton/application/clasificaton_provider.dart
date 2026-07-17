import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/waste_repository.dart';
import '../models/clasificaton_state.dart';
import '../models/waste_item.dart';

class ClasificatonController extends StateNotifier<ClasificatonState> {
  ClasificatonController() : super(const ClasificatonState());

  static const totalWastes = 33;
  static const totalMathCards = 15;
  final Random _random = Random();
  Timer? _timer;
  List<WasteItem> _wastes = [];

  void showLevels() => state = state.copyWith(phase: ClasificatonPhase.levels);

  void startLevel(int level) {
    _timer?.cancel();
    _wastes = WasteRepository.getItems()..shuffle(_random);
    state = ClasificatonState(level: level, phase: ClasificatonPhase.countdown);
  }

  void startSorting() {
    state = state.copyWith(
      phase: ClasificatonPhase.sorting,
      currentWaste: _wastes.first,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.secondsLeft <= 1) {
        _finishSorting();
      } else {
        state = state.copyWith(secondsLeft: state.secondsLeft - 1);
      }
    });
  }

  void validateAnswer(WasteType selectedType) {
    if (state.phase != ClasificatonPhase.sorting) {
      return;
    }
    final isCorrect = state.currentWaste!.type == selectedType;
    final combo = isCorrect ? state.combo + 1 : 0;
    final multiplier = combo >= 4
        ? 4
        : combo >= 3
        ? 3
        : combo >= 2
        ? 2
        : 1;
    final index = state.currentIndex + 1;
    state = state.copyWith(
      score: state.score + (isCorrect ? 10 * multiplier : 0),
      correct: state.correct + (isCorrect ? 1 : 0),
      incorrect: state.incorrect + (isCorrect ? 0 : 1),
      lives: isCorrect ? state.lives : max(0, state.lives - 1),
      combo: combo,
      currentIndex: index,
      lastTarget: selectedType,
      lastAnswerCorrect: isCorrect,
    );
    if (index >= totalWastes || state.lives == 0) {
      _finishSorting();
    } else {
      Future<void>.delayed(const Duration(milliseconds: 380), () {
        if (mounted && state.phase == ClasificatonPhase.sorting) {
          state = state.copyWith(currentWaste: _wastes[index % _wastes.length]);
        }
      });
    }
  }

  void _finishSorting() {
    _timer?.cancel();
    if (state.phase == ClasificatonPhase.sorting) {
      state = state.copyWith(
        phase: ClasificatonPhase.math,
        mathStage: MathCardStage.preview,
      );
    }
  }

  void showPreview() {
    state = state.copyWith(mathStage: MathCardStage.preview);
  }

  void showQuestion() {
    state = state.copyWith(mathStage: MathCardStage.question);
  }

  void showFeedback() {
    state = state.copyWith(mathStage: MathCardStage.feedback);
  }

  void hideMathCard() {
    state = state.copyWith(mathStage: MathCardStage.hidden);
  }

  void answerMath(int option) {
    if (state.phase != ClasificatonPhase.math) return;
    if (state.mathStage != MathCardStage.question) {
      return;
    }
    final correct = option == state.mathIndex % 4;
    final next = state.mathIndex + 1;
    state = state.copyWith(
      mathScore: state.mathScore + (correct ? 20 : 0),
      mathCorrect: state.mathCorrect + (correct ? 1 : 0),
      mathIndex: next,
      phase: next >= totalMathCards
          ? ClasificatonPhase.results
          : ClasificatonPhase.math,
      mathStage: next >= totalMathCards
          ? MathCardStage.hidden
          : MathCardStage.preview,
    );
  }

  void replay() => startLevel(state.level);
  void reset() {
    _timer?.cancel();
    state = const ClasificatonState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final clasificatonProvider =
    StateNotifierProvider<ClasificatonController, ClasificatonState>(
      (ref) => ClasificatonController(),
    );
