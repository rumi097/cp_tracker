import 'package:flutter/foundation.dart';
import '../models/contest.dart';
import '../services/contest_service.dart';

class ContestProvider extends ChangeNotifier {
  final ContestService _service;
  List<Contest> _allContests = [];
  List<Contest> _contests = [];
  bool _loading = false;
  String? _error;
  String? _selectedPlatform;

  ContestProvider(this._service);

  List<Contest> get contests => List.unmodifiable(_contests);
  List<Contest> get allContests => List.unmodifiable(_allContests);
  bool get loading => _loading;
  String? get error => _error;
  String? get selectedPlatform => _selectedPlatform;

  List<String> get availablePlatforms {
    final platforms = _allContests.map((c) => c.platform).toSet().toList();
    platforms.sort();
    return platforms;
  }

  void filterByPlatform(String? platform) {
    _selectedPlatform = platform;
    if (platform == null || platform.isEmpty) {
      _contests = List.from(_allContests);
    } else {
      _contests = _allContests.where((c) => c.platform == platform).toList();
    }
    notifyListeners();
  }

  Future<void> refresh({List<String>? platforms}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final list = await _service.fetchUpcoming(platforms: platforms);
      _allContests = list;
      filterByPlatform(_selectedPlatform);
      // Note: Contest reminders removed as notification service was refactored
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
