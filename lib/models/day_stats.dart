import 'problem_log.dart';

class DayStats {
  final DateTime day; // normalized to local midnight
  final List<ProblemLog> problems;

  DayStats({required this.day, required this.problems});

  int get count => problems.length;

  Map<String, dynamic> toJson() => {
        'day': day.toIso8601String(),
        'problems': problems.map((p) => p.toJson()).toList(),
      };

  factory DayStats.fromJson(Map<String, dynamic> json) => DayStats(
        day: DateTime.parse(json['day'] as String),
        problems: (json['problems'] as List<dynamic>)
            .map((e) => ProblemLog.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
