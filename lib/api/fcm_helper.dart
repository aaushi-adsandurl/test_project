import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class FcmHelper {
  FcmHelper._();

  static FcmHelper get instance {
    return FcmHelper._();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;

    final initializationSettingsAndroid = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channel.description,
      icon: 'launch_background',
    );

    final android = message.notification?.android;

    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      sound: 'slow_spring_board.aiff',
    );
    final platformChannelSpecifics = NotificationDetails(
      android: initializationSettingsAndroid,
      iOS: iOSPlatformChannelSpecifics,
    );

    if (notification != null && android != null) {
      printInfo(
        info: 'notification: ${notification.title.toString()}'
            '\nData: ${message.data.toString()}',
      );

      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformChannelSpecifics,
      );
    }
  }

  Future<dynamic> onSelectNotification(String payload) async {}

  Future<void> initNotification() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('launch_background');

    const initializationSettingsIOS = IOSInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future<void> initFirebase() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });
    FirebaseMessaging.onBackgroundMessage(
      _myBackgroundMessageHandler,
    );

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      sound: true,
      badge: true,
      alert: true,
    );

    await initNotification();
    final token = await FirebaseMessaging.instance.getToken();
    print(token);
  }
}

Future<void> _myBackgroundMessageHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'soft prodigy',
  'soft prodigy',
  'This channel is used for order notifications.',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
