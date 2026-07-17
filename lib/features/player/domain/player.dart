class Player {
  final String id;
  final String name;
  final int avatar;
  final int level;
  final int xp;
  final int ecoCoins;

  const Player({
    required this.id,
    required this.name,
    required this.avatar,
    required this.level,
    required this.xp,
    required this.ecoCoins,
  });

  Player copyWith({
    String? id,
    String? name,
    int? avatar,
    int? level,
    int? xp,
    int? ecoCoins,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      ecoCoins: ecoCoins ?? this.ecoCoins,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'level': level,
      'xp': xp,
      'ecoCoins': ecoCoins,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'],
      name: map['name'],
      avatar: map['avatar'],
      level: map['level'],
      xp: map['xp'],
      ecoCoins: map['ecoCoins'],
    );
  }
}
