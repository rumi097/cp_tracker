import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/problem_log.dart';
import '../models/streak_state.dart';

class StorageService {
  static const _problemLogsKey = 'problem_logs_v1';
  static const _streakStateKey = 'streak_state_v1';
  static const _usernamesKey = 'platform_usernames';
  static const _streakThresholdKey = 'streak_threshold';
  static const _notificationTimesKey = 'notification_times';
  static const _motivationalEnabledKey = 'motivational_enabled';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<List<ProblemLog>> loadProblemLogs() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_problemLogsKey);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => ProblemLog.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveProblemLogs(List<ProblemLog> logs) async {
    final prefs = await _prefs;
    final encoded = jsonEncode(logs.map((e) => e.toJson()).toList());
    await prefs.setString(_problemLogsKey, encoded);
  }

  Future<StreakState> loadStreakState() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_streakStateKey);
    if (raw == null) {
      return StreakState(currentStreak: 0, maxStreak: 0, lastUpdatedDay: null);
    }
    return StreakState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveStreakState(StreakState state) async {
    final prefs = await _prefs;
    await prefs.setString(_streakStateKey, jsonEncode(state.toJson()));
  }

  // Platform usernames
  Future<Map<String, String>> loadUsernames() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_usernamesKey);
    if (raw == null) return {};
    return Map<String, String>.from(jsonDecode(raw) as Map);
  }

  Future<void> saveUsernames(Map<String, String> usernames) async {
    final prefs = await _prefs;
    await prefs.setString(_usernamesKey, jsonEncode(usernames));
  }

  // Streak threshold
  Future<int> loadStreakThreshold() async {
    final prefs = await _prefs;
    return prefs.getInt(_streakThresholdKey) ?? 3;
  }

  Future<void> saveStreakThreshold(int threshold) async {
    final prefs = await _prefs;
    await prefs.setInt(_streakThresholdKey, threshold);
  }

  // Notification times
  Future<List<String>> loadNotificationTimes() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_notificationTimesKey);
    if (raw == null) {
      return ['09:00', '14:00', '18:00', '21:00'];
    }
    final data = jsonDecode(raw) as List<dynamic>;
    return data.map((e) => e.toString()).toList();
  }

  Future<void> saveNotificationTimes(List<String> times) async {
    final prefs = await _prefs;
    await prefs.setString(_notificationTimesKey, jsonEncode(times));
  }

  // Motivational notifications
  Future<bool> loadMotivationalEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_motivationalEnabledKey) ?? true;
  }

  Future<void> saveMotivationalEnabled(bool enabled) async {
    final prefs = await _prefs;
    await prefs.setBool(_motivationalEnabledKey, enabled);
  }
}
