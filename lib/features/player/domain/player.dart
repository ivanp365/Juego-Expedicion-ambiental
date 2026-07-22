/// Modelo del jugador con todo su progreso persistente.
/// Usa toMap/fromMap para serialización JSON en Hive.
class Player {
  final String id;
  final String name;
  final int avatar;
  final int level;
  final int xp;
  final int ecoCoins;

  // ═══════════════════════════════════════════════════════════════════════
  // NUEVOS CAMPOS PARA PROGRESO
  // ═══════════════════════════════════════════════════════════════════════
  /// Lista de IDs de logros obtenidos
  final List<String> achievements;

  /// Mapa de niveles desbloqueados por juego
  /// Ej: {'clasificaton': [1, 2], 'lombri_carrera': [], 'tesoros': []}
  final Map<String, List<int>> unlockedLevels;

  /// Niveles completados por juego (para calcular porcentaje)
  final Map<String, List<int>> completedLevels;

  /// Estadísticas totales
  final int totalEcoCoinsEarned;
  final int totalXPEarned;
  final int gamesCompleted;

  const Player({
    required this.id,
    required this.name,
    required this.avatar,
    required this.level,
    required this.xp,
    required this.ecoCoins,
    this.achievements = const [],
    this.unlockedLevels = const {
      'clasificaton': [1],
      'lombri_carrera': [],
      'tesoros_ambientales': [],
    },
    this.completedLevels = const {
      'clasificaton': [],
      'lombri_carrera': [],
      'tesoros_ambientales': [],
    },
    this.totalEcoCoinsEarned = 0,
    this.totalXPEarned = 0,
    this.gamesCompleted = 0,
  });

  Player copyWith({
    String? id,
    String? name,
    int? avatar,
    int? level,
    int? xp,
    int? ecoCoins,
    List<String>? achievements,
    Map<String, List<int>>? unlockedLevels,
    Map<String, List<int>>? completedLevels,
    int? totalEcoCoinsEarned,
    int? totalXPEarned,
    int? gamesCompleted,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      ecoCoins: ecoCoins ?? this.ecoCoins,
      achievements: achievements ?? this.achievements,
      unlockedLevels: unlockedLevels ?? this.unlockedLevels,
      completedLevels: completedLevels ?? this.completedLevels,
      totalEcoCoinsEarned: totalEcoCoinsEarned ?? this.totalEcoCoinsEarned,
      totalXPEarned: totalXPEarned ?? this.totalXPEarned,
      gamesCompleted: gamesCompleted ?? this.gamesCompleted,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // HELPERS PARA DESBLOQUEO DE NIVELES
  // ═══════════════════════════════════════════════════════════════════════

  /// Verifica si un nivel específico está desbloqueado
  bool isLevelUnlocked(String game, int level) {
    final levels = unlockedLevels[game] ?? [];
    return levels.contains(level);
  }

  /// Verifica si un nivel específico está completado
  bool isLevelCompleted(String game, int level) {
    final levels = completedLevels[game] ?? [];
    return levels.contains(level);
  }

  /// Obtiene el máximo nivel desbloqueado para un juego
  int maxUnlockedLevel(String game) {
    final levels = unlockedLevels[game] ?? [];
    if (levels.isEmpty) return 0;
    return levels.reduce((a, b) => a > b ? a : b);
  }

  /// Obtiene el porcentaje de progreso de un juego (0-100)
  double gameProgressPercent(String game, int totalLevels) {
    final completed = (completedLevels[game] ?? []).length;
    if (totalLevels == 0) return 0;
    return (completed / totalLevels) * 100;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // SERIALIZACIÓN JSON (para Hive)
  // ═══════════════════════════════════════════════════════════════════════

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'level': level,
      'xp': xp,
      'ecoCoins': ecoCoins,
      'achievements': achievements,
      'unlockedLevels': unlockedLevels,
      'completedLevels': completedLevels,
      'totalEcoCoinsEarned': totalEcoCoinsEarned,
      'totalXPEarned': totalXPEarned,
      'gamesCompleted': gamesCompleted,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'] as String,
      name: map['name'] as String,
      avatar: map['avatar'] as int,
      level: map['level'] as int,
      xp: map['xp'] as int,
      ecoCoins: map['ecoCoins'] as int,
      achievements: List<String>.from(map['achievements'] ?? []),
      unlockedLevels:
          (map['unlockedLevels'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, List<int>.from(value)),
          ) ??
          {
            'clasificaton': [1],
            'lombri_carrera': [],
            'tesoros_ambientales': [],
          },
      completedLevels:
          (map['completedLevels'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, List<int>.from(value)),
          ) ??
          {'clasificaton': [], 'lombri_carrera': [], 'tesoros_ambientales': []},
      totalEcoCoinsEarned: map['totalEcoCoinsEarned'] as int? ?? 0,
      totalXPEarned: map['totalXPEarned'] as int? ?? 0,
      gamesCompleted: map['gamesCompleted'] as int? ?? 0,
    );
  }
}
