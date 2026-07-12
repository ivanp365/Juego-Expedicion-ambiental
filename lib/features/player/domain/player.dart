class Player {
  final String id;
  final String name;
  final int level;
  final int xp;
  final int ecoCoins;

  const Player({
    required this.id,
    required this.name,
    required this.level,
    required this.xp,
    required this.ecoCoins,
  });

  Player copyWith({
    String? id,
    String? name,
    int? level,
    int? xp,
    int? ecoCoins,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      ecoCoins: ecoCoins ?? this.ecoCoins,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'xp': xp,
      'ecoCoins': ecoCoins,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      level: json['level'],
      xp: json['xp'],
      ecoCoins: json['ecoCoins'],
    );
  }
}
