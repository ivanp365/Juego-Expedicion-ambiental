import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/player.dart';

final playerProvider = StateNotifierProvider<PlayerNotifier, Player>((ref) {
  return PlayerNotifier();
});

class PlayerNotifier extends StateNotifier<Player> {
  PlayerNotifier()
    : super(
        const Player(
          id: 'player_001',
          name: 'Explorador',
          avatar: 0,
          level: 1,
          xp: 0,
          ecoCoins: 0,
        ),
      );

  void setPlayer(Player player) => state = player;
}
