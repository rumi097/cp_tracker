class Contest {
  final String platform;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final String? url;

  Contest({
    required this.platform,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    this.url,
  });

  factory Contest.fromJson(Map<String, dynamic> json) {
    final start = DateTime.fromMillisecondsSinceEpoch((json['startTime'] as int) * 1000, isUtc: true).toLocal();
    final end = DateTime.fromMillisecondsSinceEpoch((json['endTime'] as int) * 1000, isUtc: true).toLocal();
    return Contest(
      platform: json['platform'] ?? 'Unknown',
      name: json['name'] ?? '',
      startTime: start,
      endTime: end,
      durationMinutes: json['duration'] != null ? (json['duration'] as num).toInt() : end.difference(start).inMinutes,
      url: json['url'] as String?,
    );
  }
}
