import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/services/storage_service.dart';

final notificationServiceProvider = Provider((ref) => NotificationService());

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final _storage = StorageService();

  Future<void> initialize(String userId) async {
    final bool notificationsEnabledInStorage = await _storage.getNotificationsEnabled() ?? true;

    if (!notificationsEnabledInStorage) {
      return; 
    }

    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized || settings.authorizationStatus == AuthorizationStatus.provisional) {
      saveMyToken(userId);
      _configurarListenerForeground();
    }
  }

  Future<void> _configurarListenerForeground() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'Zumbidos de Sueño',
              channelDescription: 'Este canal se usa para los zumbidos de tu pareja.',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
  }

  Future<void> saveMyToken(String userId) async {
    String? currentToken = await _fcm.getToken();
    if (currentToken == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      String? savedToken = userDoc.data()?['fcmToken'];
      if (savedToken != currentToken) {
        await userDoc.reference.update({'fcmToken': currentToken});
      }
    }
  }
}