import 'package:hive_flutter/hive_flutter.dart';

/// Servicio centralizado de persistencia con Hive.
/// Abre y gestiona las boxes necesarias para toda la aplicación.
class HiveService {
  HiveService._();

  static Box<dynamic>? _playerBox;
  static Box<dynamic>? _gameStateBox;

  /// Inicializa Hive y abre todas las boxes necesarias.
  static Future<void> initialize() async {
    await Hive.initFlutter();

    _playerBox = await Hive.openBox<dynamic>('player');
    _gameStateBox = await Hive.openBox<dynamic>('game_state');
  }

  /// Box para datos del jugador (perfil, XP, EcoCoins, logros, niveles desbloqueados)
  static Box<dynamic> get playerBox {
    if (_playerBox == null) {
      throw StateError(
        'HiveService no inicializado. Llama initialize() primero.',
      );
    }
    return _playerBox!;
  }

  /// Box para estado de partidas en progreso (guardado automático)
  static Box<dynamic> get gameStateBox {
    if (_gameStateBox == null) {
      throw StateError(
        'HiveService no inicializado. Llama initialize() primero.',
      );
    }
    return _gameStateBox!;
  }

  /// Guarda un mapa JSON en la box del jugador
  static Future<void> savePlayer(Map<String, dynamic> data) async {
    await playerBox.put('player_data', data);
  }

  /// Recupera el mapa JSON del jugador, o null si no existe
  static Map<String, dynamic>? getPlayer() {
    final data = playerBox.get('player_data');
    if (data == null) return null;
    return Map<String, dynamic>.from(data as Map);
  }

  /// Guarda el estado de una partida en progreso
  static Future<void> saveGameState(
    String gameId,
    Map<String, dynamic> state,
  ) async {
    await gameStateBox.put('${gameId}_state', state);
  }

  /// Recupera el estado de una partida en progreso
  static Map<String, dynamic>? getGameState(String gameId) {
    final data = gameStateBox.get('${gameId}_state');
    if (data == null) return null;
    return Map<String, dynamic>.from(data as Map);
  }

  /// Elimina el estado de una partida (al terminar o al empezar de nuevo)
  static Future<void> clearGameState(String gameId) async {
    await gameStateBox.delete('${gameId}_state');
  }

  /// Verifica si existe una partida guardada
  static bool hasGameState(String gameId) {
    return gameStateBox.containsKey('${gameId}_state');
  }

  static Future<void> clearAll() async {
    await playerBox.clear();
    await gameStateBox.clear();
  }
}
