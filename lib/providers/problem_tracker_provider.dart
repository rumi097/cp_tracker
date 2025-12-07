import 'package:flutter/foundation.dart';
import '../models/problem_log.dart';
import '../models/streak_state.dart';
import '../services/storage_service.dart';
import '../services/submission_service.dart';

class ProblemTrackerProvider extends ChangeNotifier {
  final StorageService _storage;
  final SubmissionService _submissionService;
  
  int _streakThreshold = 3; // problems per day to count as streak day
  Map<String, String> _usernames = {};
  bool _isAutoSyncing = false;

  List<ProblemLog> _logs = [];
  StreakState _streak = StreakState(currentStreak: 0, maxStreak: 0, lastUpdatedDay: null);

  ProblemTrackerProvider(this._storage, this._submissionService);

  List<ProblemLog> get logs => List.unmodifiable(_logs);
  StreakState get streak => _streak;
  int get streakThreshold => _streakThreshold;
  Map<String, String> get usernames => Map.unmodifiable(_usernames);
  bool get isAutoSyncing => _isAutoSyncing;

  int problemsSolvedToday() {
    final today = DateTime.now();
    return _logs.where((l) => l.timestamp.year == today.year && l.timestamp.month == today.month && l.timestamp.day == today.day).length;
  }

  Future<void> load() async {
    _logs = await _storage.loadProblemLogs();
    _streak = await _storage.loadStreakState();
    _streakThreshold = await _storage.loadStreakThreshold();
    _usernames = await _storage.loadUsernames();
    _recalculateStreak(processToday: false);
    notifyListeners();
  }

  Future<void> updateStreakThreshold(int newThreshold) async {
    if (newThreshold < 1) return;
    _streakThreshold = newThreshold;
    await _storage.saveStreakThreshold(newThreshold);
    _recalculateStreak();
    notifyListeners();
  }

  Future<void> updateUsernames(Map<String, String> newUsernames) async {
    _usernames = Map.from(newUsernames);
    await _storage.saveUsernames(_usernames);
    notifyListeners();
  }

  Future<void> syncFromPlatforms() async {
    if (_isAutoSyncing || _usernames.isEmpty) return;
    
    _isAutoSyncing = true;
    notifyListeners();

    try {
      final counts = await _submissionService.fetchAllPlatformsToday(_usernames);
      final today = DateTime.now();
      final todayMidnight = DateTime(today.year, today.month, today.day);
      
      // Remove today's auto-synced logs to avoid duplicates
      _logs.removeWhere((log) {
        final logDay = DateTime(log.timestamp.year, log.timestamp.month, log.timestamp.day);
        return logDay.isAtSameMomentAs(todayMidnight) && log.problemId == 'auto_sync';
      });
      
      // Add new auto-synced problems
      counts.forEach((platform, count) {
        for (int i = 0; i < count; i++) {
          _logs.add(ProblemLog(
            timestamp: today,
            platform: platform,
            difficulty: 'Auto',
            problemId: 'auto_sync',
          ));
        }
      });
      
      await _storage.saveProblemLogs(_logs);
      _recalculateStreak();
    } catch (e) {
      debugPrint('Auto-sync error: $e');
    } finally {
      _isAutoSyncing = false;
      notifyListeners();
    }
  }

  void logProblem({required String platform, String difficulty = 'Unrated', String? problemId}) {
    final entry = ProblemLog(timestamp: DateTime.now(), platform: platform, difficulty: difficulty, problemId: problemId);
    _logs.add(entry);
    _storage.saveProblemLogs(_logs);
    _recalculateStreak();
    notifyListeners();
  }

  void _recalculateStreak({bool processToday = true}) {
    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);
    final Map<DateTime, int> dayCounts = {};
    for (final log in _logs) {
      final d = DateTime(log.timestamp.year, log.timestamp.month, log.timestamp.day);
      dayCounts[d] = (dayCounts[d] ?? 0) + 1;
    }

    int streakValue = 0;
    DateTime? lastUpdated = _streak.lastUpdatedDay;
    if (lastUpdated == null) {
      final days = dayCounts.keys.toList()..sort();
      for (final d in days) {
        if (dayCounts[d]! >= _streakThreshold) {
          if (streakValue == 0) {
            streakValue = 1;
          } else {
            final prev = d.subtract(const Duration(days: 1));
            if (dayCounts.containsKey(prev) && dayCounts[prev]! >= _streakThreshold) {
              streakValue += 1;
            } else {
              streakValue = 1;
            }
          }
          if (streakValue > _streak.maxStreak) {
            _streak = _streak.copyWith(maxStreak: streakValue);
          }
        }
        lastUpdated = d;
      }
    } else {
      streakValue = _streak.currentStreak;
    }

    if (processToday) {
      if (_streak.lastUpdatedDay != null) {
        final lastDay = DateTime(_streak.lastUpdatedDay!.year, _streak.lastUpdatedDay!.month, _streak.lastUpdatedDay!.day);
        if (lastDay.isBefore(todayMidnight)) {
          final yesterday = todayMidnight.subtract(const Duration(days: 1));
          final yesterdayCount = dayCounts[yesterday] ?? 0;
          if (yesterdayCount < _streakThreshold) {
            streakValue = 0;
          }
        }
      }

      final todayCount = dayCounts[todayMidnight] ?? 0;
      if (todayCount >= _streakThreshold) {
        final prevDay = todayMidnight.subtract(const Duration(days: 1));
        final prevMet = (dayCounts[prevDay] ?? 0) >= _streakThreshold;
        streakValue = prevMet ? streakValue + 1 : 1;
        if (streakValue > _streak.maxStreak) {
          _streak = _streak.copyWith(maxStreak: streakValue);
        }
      }
      lastUpdated = todayMidnight;
    }

    _streak = _streak.copyWith(currentStreak: streakValue, lastUpdatedDay: lastUpdated);
    _storage.saveStreakState(_streak);
  }
}
