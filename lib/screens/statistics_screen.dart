import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/problem_tracker_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<ProblemTrackerProvider>();
    final logs = tracker.logs;

    // Calculate platform stats
    final platformCounts = <String, int>{};
    for (final log in logs) {
      platformCounts[log.platform] = (platformCounts[log.platform] ?? 0) + 1;
    }

    // Calculate difficulty stats
    final difficultyCounts = <String, int>{};
    for (final log in logs) {
      difficultyCounts[log.difficulty] = (difficultyCounts[log.difficulty] ?? 0) + 1;
    }

    // Last 7 days activity
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return DateTime(day.year, day.month, day.day);
    });
    final weeklyActivity = <DateTime, int>{};
    for (final day in last7Days) {
      weeklyActivity[day] = logs.where((l) {
        final logDay = DateTime(l.timestamp.year, l.timestamp.month, l.timestamp.day);
        return logDay == day;
      }).length;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Total Problems Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.emoji_events, color: Colors.white, size: 48),
                const SizedBox(height: 8),
                Text(
                  '${logs.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Total Problems Solved',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Platform Breakdown
          Text('By Platform', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...platformCounts.entries.map((e) => _BarItem(
                label: e.key,
                count: e.value,
                total: logs.length,
                color: _getPlatformColor(e.key),
              )),
          const SizedBox(height: 24),

          // Difficulty Breakdown
          Text('By Difficulty', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...difficultyCounts.entries.map((e) => _BarItem(
                label: e.key,
                count: e.value,
                total: logs.length,
                color: _getDifficultyColor(e.key),
              )),
          const SizedBox(height: 24),

          // Weekly Activity
          Text('Last 7 Days', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: weeklyActivity.entries.map((e) {
                final maxCount = weeklyActivity.values.isEmpty ? 1 : weeklyActivity.values.reduce((a, b) => a > b ? a : b);
                final height = maxCount > 0 ? (e.value / maxCount * 150).clamp(20.0, 150.0) : 20.0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${e.value}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 40,
                      height: height,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getDayLabel(e.key),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPlatformColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'codeforces':
        return Colors.blue;
      case 'leetcode':
        return Colors.orange;
      case 'codechef':
        return Colors.brown;
      case 'atcoder':
        return Colors.grey;
      case 'geeksforgeeks':
        return Colors.green;
      case 'codingninja':
      case 'codingninjas':
        return Colors.red;
      default:
        return Colors.purple;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getDayLabel(DateTime date) {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday % 7];
  }
}

class _BarItem extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _BarItem({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (count / total * 100).toStringAsFixed(1) : '0.0';
    final barWidth = total > 0 ? (count / total).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text('$count ($percentage%)', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: barWidth,
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
