import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/player_repository.dart';
import '../domain/player.dart';
import 'player_provider.dart';

final playerServiceProvider = Provider<PlayerService>((ref) {
  return PlayerService(ref, const PlayerRepository());
});

class PlayerService {
  final Ref ref;
  final PlayerRepository _repository;

  PlayerService(this.ref, this._repository);

  Future<void> loadFromStorage() async {
    final saved = _repository.load();
    if (saved != null) {
      ref.read(playerProvider.notifier).setPlayer(saved);
    } else {
      final defaultPlayer = _createDefaultPlayer();
      await saveToStorage(defaultPlayer);
      ref.read(playerProvider.notifier).setPlayer(defaultPlayer);
    }
  }

  Future<void> saveToStorage([Player? player]) async {
    final Player toSave = player ?? ref.read(playerProvider);

    await _repository.save(toSave);
  }

  Player _createDefaultPlayer() => const Player(
    id: 'player_001',
    name: 'Explorador',
    avatar: 0,
    level: 1,
    xp: 0,
    ecoCoins: 0,
  );

  void updatePlayer(Player player) {
    ref.read(playerProvider.notifier).setPlayer(player);
    saveToStorage(player);
  }

  void addXP(int amount) {
    final player = ref.read(playerProvider);
    int newXP = player.xp + amount;
    int newLevel = player.level;

    while (newXP >= 100) {
      newXP -= 100;
      newLevel++;
    }

    final updated = player.copyWith(
      xp: newXP,
      level: newLevel,
      totalXPEarned: player.totalXPEarned + amount,
    );
    updatePlayer(updated);
  }

  void addEcoCoins(int amount) {
    final player = ref.read(playerProvider);
    final updated = player.copyWith(
      ecoCoins: player.ecoCoins + amount,
      totalEcoCoinsEarned: player.totalEcoCoinsEarned + amount,
    );
    updatePlayer(updated);
  }

  void unlockLevel(String game, int level) {
    final player = ref.read(playerProvider);
    final current = List<int>.from(player.unlockedLevels[game] ?? []);

    if (!current.contains(level)) {
      current.add(level);
      current.sort();

      final updatedLevels = Map<String, List<int>>.from(player.unlockedLevels);
      updatedLevels[game] = current;

      updatePlayer(player.copyWith(unlockedLevels: updatedLevels));
    }
  }

  void completeLevel(String game, int level, int totalLevels) {
    final player = ref.read(playerProvider);
    final completed = List<int>.from(player.completedLevels[game] ?? []);

    if (!completed.contains(level)) {
      completed.add(level);
      completed.sort();
    }

    final updatedCompleted = Map<String, List<int>>.from(
      player.completedLevels,
    );
    updatedCompleted[game] = completed;

    final nextLevel = level + 1;
    if (nextLevel <= totalLevels) {
      unlockLevel(game, nextLevel);
    }

    updatePlayer(
      player.copyWith(
        completedLevels: updatedCompleted,
        gamesCompleted: player.gamesCompleted + 1,
      ),
    );
  }

  void addAchievement(String achievementId) {
    final player = ref.read(playerProvider);
    if (player.achievements.contains(achievementId)) return;

    final updated = List<String>.from(player.achievements)..add(achievementId);
    updatePlayer(player.copyWith(achievements: updated));
  }

  Future<void> awardClasificatonCompletion({
    required int level,
    required int score,
    required int correctAnswers,
    required int mathCorrect,
    required int secondsLeft,
  }) async {
    final xpFromSorting = correctAnswers * 10;
    final xpFromMath = mathCorrect * 25;
    final completionBonus = 100;
    final totalXP = xpFromSorting + xpFromMath + completionBonus;

    final ecoFromSorting = correctAnswers * 2;
    final completionEcoBonus = 10;
    final totalEco = ecoFromSorting + completionEcoBonus;

    addXP(totalXP);
    addEcoCoins(totalEco);

    completeLevel('clasificaton', level, 2);

    if (level == 1) addAchievement('clasificaton_level1_complete');
    if (level == 2) addAchievement('clasificaton_level2_complete');
    if (score >= 500) addAchievement('clasificaton_high_score');
    if (secondsLeft > 60) addAchievement('clasificaton_speed_demon');
  }
}
