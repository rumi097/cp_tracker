class StreakState {
  final int currentStreak; // consecutive days meeting threshold
  final int maxStreak;
  final DateTime? lastUpdatedDay; // last day we processed streak logic

  StreakState({
    required this.currentStreak,
    required this.maxStreak,
    required this.lastUpdatedDay,
  });

  Map<String, dynamic> toJson() => {
        'currentStreak': currentStreak,
        'maxStreak': maxStreak,
        'lastUpdatedDay': lastUpdatedDay?.toIso8601String(),
      };

  factory StreakState.fromJson(Map<String, dynamic> json) => StreakState(
        currentStreak: json['currentStreak'] as int? ?? 0,
        maxStreak: json['maxStreak'] as int? ?? 0,
        lastUpdatedDay: json['lastUpdatedDay'] != null
            ? DateTime.parse(json['lastUpdatedDay'] as String)
            : null,
      );

  StreakState copyWith({int? currentStreak, int? maxStreak, DateTime? lastUpdatedDay}) => StreakState(
        currentStreak: currentStreak ?? this.currentStreak,
        maxStreak: maxStreak ?? this.maxStreak,
        lastUpdatedDay: lastUpdatedDay ?? this.lastUpdatedDay,
      );
}
