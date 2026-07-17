import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/player.dart';

final playerProvider = StateProvider<Player>(
  (ref) => const Player(
    id: 'player_001',
    name: 'Explorador',
    avatar: 0,
    level: 1,
    xp: 0,
    ecoCoins: 0,
  ),
);
