import '../../../core/database/hive_service.dart';
import '../domain/player.dart';

/// Repositorio de persistencia del jugador usando Hive.
class PlayerRepository {
  const PlayerRepository();

  Future<void> save(Player player) async {
    await HiveService.savePlayer(player.toMap());
  }

  Player? load() {
    final data = HiveService.getPlayer();
    if (data == null) return null;
    return Player.fromMap(data);
  }

  bool exists() => HiveService.getPlayer() != null;

  Future<void> delete() async {
    await HiveService.playerBox.delete('player_data');
  }
}
