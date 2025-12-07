import 'package:flutter/foundation.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service;
  final StorageService _storage;
  bool _initialized = false;
  List<String> _notificationTimes = [];

  NotificationProvider(this._service, this._storage);

  bool get initialized => _initialized;
  List<String> get notificationTimes => List.unmodifiable(_notificationTimes);

  Future<void> init() async {
    _notificationTimes = await _storage.loadNotificationTimes();
    notifyListeners();
  }

  Future<void> enableNotifications() async {
    if (_initialized) return;
    await _service.init();
    await scheduleAllNotifications();
    _initialized = true;
    notifyListeners();
  }

  Future<void> disableNotifications() async {
    if (!_initialized) return;
    await _service.cancelAll();
    _initialized = false;
    notifyListeners();
  }

  Future<void> scheduleAllNotifications() async {
    await _service.scheduleCustomNotifications(_notificationTimes);
  }

  Future<void> addNotificationTime(String time) async {
    if (_notificationTimes.contains(time)) return;
    _notificationTimes.add(time);
    _notificationTimes.sort();
    await _storage.saveNotificationTimes(_notificationTimes);
    if (_initialized) {
      await _service.cancelAll();
      await scheduleAllNotifications();
    }
    notifyListeners();
  }

  Future<void> removeNotificationTime(String time) async {
    _notificationTimes.remove(time);
    await _storage.saveNotificationTimes(_notificationTimes);
    if (_initialized) {
      await _service.cancelAll();
      await scheduleAllNotifications();
    }
    notifyListeners();
  }
}
