import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/constants.dart';

class FcmService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    print("FCM: Initializing...");
    
    // 1. Request Permission (iOS & Android 13+)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('FCM: User permission status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // 2. Get Token
      try {
        String? token = await _messaging.getToken();
        if (token != null) {
          print("FCM Token Found: $token");
          await _saveTokenToBackend(token);
        }
      } catch (e) {
        print("FCM Error getting token: $e");
      }
    }

    // 3. Initialize Local Notifications (for Foreground)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    
    await _localNotifications.initialize(initializationSettings);

    // 4. Listeners
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("FCM: Received message in foreground: ${message.notification?.title}");
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("FCM: Notification clicked: ${message.notification?.title}");
      // Navigate if needed: Get.toNamed('/notifikasi');
    });
  }

  static void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // id
            'High Importance Notifications', // title
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }

  static Future<void> _saveTokenToBackend(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('token');
      
      if (userToken == null) {
        print("FCM: Sanctum Token is missing in SharedPreferences");
        return;
      }

      print("FCM: Sending token to backend...");
      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}/update-fcm-token"),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Accept': 'application/json',
        },
        body: {'fcm_token': token},
      );

      if (response.statusCode == 200) {
        print("FCM: Token successfully saved to database!");
      } else {
        print("FCM: Failed to save token. Status: ${response.statusCode}");
        print("FCM: Response body: ${response.body}");
      }
    } catch (e) {
      print("FCM Error saving FCM token to backend: $e");
    }
  }
}
