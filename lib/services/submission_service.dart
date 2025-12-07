import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class SubmissionService {
  final String baseUrl;

  SubmissionService({required this.baseUrl});

  Future<Map<String, dynamic>> fetchCodeforcesSubmissions(String username) async {
    try {
      final url = Uri.parse('$baseUrl/api/submissions/codeforces/$username');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return {'todayCount': 0, 'recentAccepted': []};
    } catch (e) {
      debugPrint('Codeforces fetch error: $e');
      return {'todayCount': 0, 'recentAccepted': []};
    }
  }

  Future<Map<String, dynamic>> fetchLeetCodeSubmissions(String username) async {
    try {
      final url = Uri.parse('$baseUrl/api/submissions/leetcode/$username');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return {'todayCount': 0, 'recentAccepted': []};
    } catch (e) {
      debugPrint('LeetCode fetch error: $e');
      return {'todayCount': 0, 'recentAccepted': []};
    }
  }

  Future<Map<String, dynamic>> fetchCodeChefSubmissions(String username) async {
    try {
      final url = Uri.parse('$baseUrl/api/submissions/codechef/$username');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return {'todayCount': 0, 'recentAccepted': []};
    } catch (e) {
      debugPrint('CodeChef fetch error: $e');
      return {'todayCount': 0, 'recentAccepted': []};
    }
  }

  Future<Map<String, dynamic>> fetchAtCoderSubmissions(String username) async {
    try {
      final url = Uri.parse('$baseUrl/api/submissions/atcoder/$username');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return {'todayCount': 0, 'recentAccepted': []};
    } catch (e) {
      debugPrint('AtCoder fetch error: $e');
      return {'todayCount': 0, 'recentAccepted': []};
    }
  }

  Future<Map<String, int>> fetchAllPlatformsToday(Map<String, String> usernames) async {
    final counts = <String, int>{};
    
    if (usernames.containsKey('Codeforces') && usernames['Codeforces']!.isNotEmpty) {
      final data = await fetchCodeforcesSubmissions(usernames['Codeforces']!);
      counts['Codeforces'] = data['todayCount'] ?? 0;
    }
    
    if (usernames.containsKey('LeetCode') && usernames['LeetCode']!.isNotEmpty) {
      final data = await fetchLeetCodeSubmissions(usernames['LeetCode']!);
      counts['LeetCode'] = data['todayCount'] ?? 0;
    }
    
    if (usernames.containsKey('CodeChef') && usernames['CodeChef']!.isNotEmpty) {
      final data = await fetchCodeChefSubmissions(usernames['CodeChef']!);
      counts['CodeChef'] = data['todayCount'] ?? 0;
    }
    
    if (usernames.containsKey('AtCoder') && usernames['AtCoder']!.isNotEmpty) {
      final data = await fetchAtCoderSubmissions(usernames['AtCoder']!);
      counts['AtCoder'] = data['todayCount'] ?? 0;
    }
    
    return counts;
  }
}
