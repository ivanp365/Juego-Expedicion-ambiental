import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/player.dart';
import 'player_provider.dart';

final playerServiceProvider = Provider<PlayerService>((ref) {
  return PlayerService(ref);
});

class PlayerService {
  final Ref ref;

  PlayerService(this.ref);

  void updatePlayer(Player player) {
    ref.read(playerProvider.notifier).state = player;
  }

  void addXP(int amount) {
    final player = ref.read(playerProvider);

    int newXP = player.xp + amount;
    int newLevel = player.level;

    while (newXP >= 100) {
      newXP -= 100;
      newLevel++;
    }

    updatePlayer(player.copyWith(xp: newXP, level: newLevel));
  }

  void addEcoCoins(int amount) {
    final player = ref.read(playerProvider);

    updatePlayer(player.copyWith(ecoCoins: player.ecoCoins + amount));
  }
}
