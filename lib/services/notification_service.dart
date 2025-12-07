import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
    
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(const InitializationSettings(android: android, iOS: ios));
    
    // Request permissions for Android 13+
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    
    // Request permissions for iOS
    await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    
    _initialized = true;
  }

  Future<void> scheduleCustomNotifications(List<String> times) async {
    await init();
    // Set timezone to Bangladesh
    tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
    
    final motivations = [
      'Keep the streak alive! 🔥',
      'Time to code! 💻',
      'Practice makes perfect! 🎯',
      'One problem closer to mastery! 🚀',
      'Keep grinding! ⚡',
      'Code your way to success! 💪',
      'Stay consistent! 📈',
      'Challenge yourself today! 🎓',
    ];
    
    for (int i = 0; i < times.length; i++) {
      final timeParts = times[i].split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      
      final now = tz.TZDateTime.now(tz.local);
      var schedule = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
      if (schedule.isBefore(now)) {
        schedule = schedule.add(const Duration(days: 1));
      }
      
      await _plugin.zonedSchedule(
        100 + i,
        motivations[i % motivations.length],
        'Solve problems to maintain your streak!',
        schedule,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminders', 
            'Daily Reminders',
            channelDescription: 'Daily motivation to solve problems',
            importance: Importance.high, 
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> instantPush(String title, String body) async {
    await init();
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails('instant_channel', 'Instant', importance: Importance.max, priority: Priority.high),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
