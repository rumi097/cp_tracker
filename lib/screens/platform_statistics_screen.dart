import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/problem_tracker_provider.dart';
import '../services/platform_stats_service.dart';

class PlatformStatisticsScreen extends StatefulWidget {
  const PlatformStatisticsScreen({super.key});

  @override
  State<PlatformStatisticsScreen> createState() => _PlatformStatisticsScreenState();
}

class _PlatformStatisticsScreenState extends State<PlatformStatisticsScreen> {
  late final PlatformStatsService _statsService;
  Map<String, PlatformStats>? _platformStats;
  bool _loadingStats = false;

  @override
  void initState() {
    super.initState();
    // Use production backend on Vercel
    _statsService = PlatformStatsService(baseUrl: 'https://cpteacker-biibp58f8-ali-azgor-rumis-projects.vercel.app');
    _loadPlatformStats();
  }

  Future<void> _loadPlatformStats() async {
    setState(() => _loadingStats = true);
    
    final tracker = context.read<ProblemTrackerProvider>();
    final usernames = {
      'codeforces': tracker.usernames['Codeforces'] ?? '',
      'leetcode': tracker.usernames['LeetCode'] ?? '',
      'atcoder': tracker.usernames['AtCoder'] ?? '',
      'codechef': tracker.usernames['CodeChef'] ?? '',
    };

    try {
      final stats = await _statsService.getAllPlatformStats(usernames);
      setState(() {
        _platformStats = stats;
        _loadingStats = false;
      });
    } catch (e) {
      setState(() => _loadingStats = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching stats: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<ProblemTrackerProvider>();
    final logs = tracker.logs;

    // Calculate platform statistics from logged problems
    final Map<String, int> platformCounts = {};
    for (final log in logs) {
      platformCounts[log.platform] = (platformCounts[log.platform] ?? 0) + 1;
    }

    // Sort platforms by count (descending)
    final sortedPlatforms = platformCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final totalProblems = logs.length;
    final platformCount = platformCounts.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadingStats ? null : _loadPlatformStats,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Real-time Platform Stats Section
          Text(
            'Platform Profile Stats',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A237E),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total problems solved on each platform (from your profile)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 16),

          if (_loadingStats)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Fetching platform statistics...'),
                    ],
                  ),
                ),
              ),
            )
          else if (_platformStats != null && _platformStats!.isNotEmpty)
            ..._platformStats!.entries.map((entry) {
              final stats = entry.value;
              final color = _getPlatformColor(stats.platform);
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.code, color: color),
                  ),
                  title: Text(
                    stats.platform,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    stats.username.isEmpty
                        ? 'No username set'
                        : 'Username: ${stats.username}',
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        stats.totalSolved.toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const Text(
                        'solved',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
          else
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'Set platform usernames in Settings to view stats',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),

          // Logged Problems Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Logged in App',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A237E),
                    ),
              ),
              Chip(
                label: Text('$totalProblems logged'),
                backgroundColor: const Color(0xFF1A237E).withValues(alpha: 0.1),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Problems you\'ve logged in this app',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 16),

          if (logs.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No problems logged yet',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else ...[
            // Summary Card
            Card(
              color: const Color(0xFF1A237E),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 48,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      totalProblems.toString(),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Total Problems Logged',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Across $platformCount Platform${platformCount != 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Platform Breakdown Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Platform Breakdown',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A237E),
                      ),
                ),
                Chip(
                  label: Text('$platformCount platforms'),
                  backgroundColor: const Color(0xFF1A237E).withValues(alpha: 0.1),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Platform List with Visual Bars
            ...sortedPlatforms.map((entry) {
              final platform = entry.key;
              final count = entry.value;
              final percentage = (count / totalProblems * 100);
              final color = _getPlatformColor(platform);

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              platform,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              count.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${percentage.toStringAsFixed(1)}%)',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        minHeight: 24,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),

            // Distribution Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distribution',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    ...sortedPlatforms.map((entry) {
                      final platform = entry.key;
                      final count = entry.value;
                      final percentage = (count / totalProblems * 100);
                      final color = _getPlatformColor(platform);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(platform),
                            ),
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Top Platform Card
            if (sortedPlatforms.isNotEmpty)
              Card(
                color: _getPlatformColor(sortedPlatforms.first.key).withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: _getPlatformColor(sortedPlatforms.first.key),
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Most Logged Platform',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              sortedPlatforms.first.key,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _getPlatformColor(sortedPlatforms.first.key),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${sortedPlatforms.first.value} problems',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Color _getPlatformColor(String platform) {
    switch (platform) {
      case 'Codeforces':
        return const Color(0xFF1F8ACB);
      case 'LeetCode':
        return const Color(0xFFFFA116);
      case 'CodeChef':
        return const Color(0xFF964B00);
      case 'AtCoder':
        return Colors.purple;
      case 'GeeksforGeeks':
        return const Color(0xFF2F8D46);
      case 'CodingNinjas':
        return const Color(0xFFDD6620);
      default:
        return Colors.grey;
    }
  }
}
