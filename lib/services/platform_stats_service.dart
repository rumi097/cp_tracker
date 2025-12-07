import 'dart:convert';
import 'package:http/http.dart' as http;

class PlatformStats {
  final String platform;
  final String username;
  final int totalSolved;
  final String? error;

  PlatformStats({
    required this.platform,
    required this.username,
    required this.totalSolved,
    this.error,
  });

  factory PlatformStats.fromJson(Map<String, dynamic> json) {
    return PlatformStats(
      platform: json['platform'] ?? '',
      username: json['username'] ?? '',
      totalSolved: json['totalSolved'] ?? 0,
      error: json['error'] ?? json['note'],
    );
  }
}

class PlatformStatsService {
  final String baseUrl;
  
  PlatformStatsService({required this.baseUrl});

  Future<PlatformStats> getCodeforcesStats(String username) async {
    if (username.isEmpty) {
      return PlatformStats(
        platform: 'Codeforces',
        username: '',
        totalSolved: 0,
        error: 'No username set',
      );
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/stats/codeforces/$username'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return PlatformStats.fromJson(json.decode(response.body));
      } else {
        return PlatformStats(
          platform: 'Codeforces',
          username: username,
          totalSolved: 0,
          error: 'Failed to fetch stats',
        );
      }
    } catch (e) {
      return PlatformStats(
        platform: 'Codeforces',
        username: username,
        totalSolved: 0,
        error: 'Error: $e',
      );
    }
  }

  Future<PlatformStats> getLeetCodeStats(String username) async {
    if (username.isEmpty) {
      return PlatformStats(
        platform: 'LeetCode',
        username: '',
        totalSolved: 0,
        error: 'No username set',
      );
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/stats/leetcode/$username'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return PlatformStats.fromJson(json.decode(response.body));
      } else {
        return PlatformStats(
          platform: 'LeetCode',
          username: username,
          totalSolved: 0,
          error: 'Failed to fetch stats',
        );
      }
    } catch (e) {
      return PlatformStats(
        platform: 'LeetCode',
        username: username,
        totalSolved: 0,
        error: 'Error: $e',
      );
    }
  }

  Future<PlatformStats> getAtCoderStats(String username) async {
    if (username.isEmpty) {
      return PlatformStats(
        platform: 'AtCoder',
        username: '',
        totalSolved: 0,
        error: 'No username set',
      );
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/stats/atcoder/$username'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return PlatformStats.fromJson(json.decode(response.body));
      } else {
        return PlatformStats(
          platform: 'AtCoder',
          username: username,
          totalSolved: 0,
          error: 'Failed to fetch stats',
        );
      }
    } catch (e) {
      return PlatformStats(
        platform: 'AtCoder',
        username: username,
        totalSolved: 0,
        error: 'Error: $e',
      );
    }
  }

  Future<PlatformStats> getCodeChefStats(String username) async {
    if (username.isEmpty) {
      return PlatformStats(
        platform: 'CodeChef',
        username: '',
        totalSolved: 0,
        error: 'No username set',
      );
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/stats/codechef/$username'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return PlatformStats.fromJson(json.decode(response.body));
      } else {
        return PlatformStats(
          platform: 'CodeChef',
          username: username,
          totalSolved: 0,
          error: 'Failed to fetch stats',
        );
      }
    } catch (e) {
      return PlatformStats(
        platform: 'CodeChef',
        username: username,
        totalSolved: 0,
        error: 'Error: $e',
      );
    }
  }

  Future<Map<String, PlatformStats>> getAllPlatformStats(Map<String, String> usernames) async {
    final results = <String, PlatformStats>{};

    // Fetch all stats in parallel
    final futures = <Future<void>>[];

    if (usernames['codeforces']?.isNotEmpty ?? false) {
      futures.add(getCodeforcesStats(usernames['codeforces']!).then((stats) {
        results['Codeforces'] = stats;
      }));
    }

    if (usernames['leetcode']?.isNotEmpty ?? false) {
      futures.add(getLeetCodeStats(usernames['leetcode']!).then((stats) {
        results['LeetCode'] = stats;
      }));
    }

    if (usernames['atcoder']?.isNotEmpty ?? false) {
      futures.add(getAtCoderStats(usernames['atcoder']!).then((stats) {
        results['AtCoder'] = stats;
      }));
    }

    if (usernames['codechef']?.isNotEmpty ?? false) {
      futures.add(getCodeChefStats(usernames['codechef']!).then((stats) {
        results['CodeChef'] = stats;
      }));
    }

    await Future.wait(futures);
    return results;
  }
}
