import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contest.dart';

class ContestService {
  final String baseUrl; // e.g. https://your-backend.example.com/contest
  ContestService({required this.baseUrl});

  Future<List<Contest>> fetchUpcoming({List<String>? platforms}) async {
    final uri = Uri.parse('$baseUrl/upcoming').replace(
      queryParameters: {
        if (platforms != null && platforms.isNotEmpty) 'platforms': jsonEncode(platforms),
      },
    );
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Failed to fetch contests: ${resp.statusCode}');
    }
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final list = data['upcoming_contests'] as List<dynamic>? ?? [];
    return list
        .map((e) => Contest.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
