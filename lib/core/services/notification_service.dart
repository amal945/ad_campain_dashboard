import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService(this._notificationsPlugin);

  final FlutterLocalNotificationsPlugin? _notificationsPlugin;

  Future<void> init() async {
    final plugin = _notificationsPlugin;
    if (plugin == null) {
      return;
    }
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await plugin.initialize(settings);
  }

  Future<void> showAnomalyNotification(String title, String body) async {
    final plugin = _notificationsPlugin;
    if (plugin == null) {
      return;
    }
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'anomaly_alerts',
        'Anomaly Alerts',
        channelDescription: 'Campaign anomaly notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    await plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}
