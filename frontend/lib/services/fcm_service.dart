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
    // 1. Request Permission
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
        } else {
          print("FCM Token is NULL");
        }
      } catch (e) {
        print("FCM Error getting token: $e");
      }
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
