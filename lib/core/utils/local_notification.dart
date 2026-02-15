import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/web.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin plugin;
  final FirebaseMessaging messaging;

  LocalNotificationService({required this.plugin, required this.messaging});

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'order_status_channel',
    'Update Pesanan',
    description: 'Notifikasi perubahan status pesanan',
    importance: Importance.high,
    playSound: true,
  );

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);

    Logger().d('LocalNotificationService initialized');
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    Logger().d('Foreground notification received: ${notification.title}');

    await plugin.show(
      id: notification.hashCode,
      title: notification.title ?? 'Notifikasi',
      body: notification.body ?? '',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data['orderId'],
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    final orderId = response.payload;
    if (orderId != null) {
      Logger().d('Notification tapped, orderId: $orderId');
    }
  }
}
