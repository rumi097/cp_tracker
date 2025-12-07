class ProblemLog {
  final DateTime timestamp;
  final String platform; // e.g., Codeforces
  final String? problemId; // optional identifier
  final String difficulty; // e.g., Easy/Medium/Hard or rating

  ProblemLog({
    required this.timestamp,
    required this.platform,
    required this.difficulty,
    this.problemId,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'platform': platform,
        'difficulty': difficulty,
        'problemId': problemId,
      };

  factory ProblemLog.fromJson(Map<String, dynamic> json) => ProblemLog(
        timestamp: DateTime.parse(json['timestamp'] as String),
        platform: json['platform'] as String,
        difficulty: json['difficulty'] as String,
        problemId: json['problemId'] as String?,
      );
}
