class UserModel {
  final int? id;
  final String username;
  final int level;
  final int xp;
  final int streak;
  final int totalXp;
  final int completedLessons;
  final int badges;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    this.id,
    required this.username,
    this.level = 1,
    this.xp = 0,
    this.streak = 0,
    this.totalXp = 0,
    this.completedLessons = 0,
    this.badges = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'level': level,
      'xp': xp,
      'streak': streak,
      'totalXp': totalXp,
      'completedLessons': completedLessons,
      'badges': badges,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create User from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      username: json['username'] as String,
      level: json['level'] as int? ?? 1,
      xp: json['xp'] as int? ?? 0,
      streak: json['streak'] as int? ?? 0,
      totalXp: json['totalXp'] as int? ?? 0,
      completedLessons: json['completedLessons'] as int? ?? 0,
      badges: json['badges'] as int? ?? 0,
      createdAt: json['createdAt'] != null && json['createdAt'].toString().isNotEmpty
          ? DateTime.parse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null && json['updatedAt'].toString().isNotEmpty
          ? DateTime.parse(json['updatedAt'].toString())
          : null,
    );
  }

  // Create a copy with modifications
  UserModel copyWith({
    int? id,
    String? username,
    int? level,
    int? xp,
    int? streak,
    int? totalXp,
    int? completedLessons,
    int? badges,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      totalXp: totalXp ?? this.totalXp,
      completedLessons: completedLessons ?? this.completedLessons,
      badges: badges ?? this.badges,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
