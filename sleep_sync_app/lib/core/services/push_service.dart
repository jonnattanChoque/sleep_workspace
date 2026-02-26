import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/services/storage_service.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';

final notificationServiceProvider = Provider((ref) => NotificationService(ref));

class NotificationService {
  final Ref ref;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final _storage = StorageService();

  NotificationService(this.ref);

  Future<void> initialize(String userId) async {
    final bool notificationsEnabledInStorage = await _storage.getNotificationsEnabled() ?? true;

    if (!notificationsEnabledInStorage) {
      return; 
    }

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // AQUÍ es donde capturamos el link cuando el usuario toca la notificación
        final String? payload = response.payload;
        if (payload != null) {
          final uri = Uri.parse(payload);
          if (uri.queryParameters['action'] == 'logout') {
            Future.microtask(() {
              ref.read(externalLogoutRequestProvider.notifier).state = true;
            });
          }
        }
      },
    );

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

      final String? link = message.data['link'];

      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'Zumbidos de Sueño',
              channelDescription: 'Este canal se usa para los zumbidos de tu pareja.',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/launcher_icon',
              styleInformation: BigTextStyleInformation(
                notification.body ?? '', // Texto que se expande
                contentTitle: notification.title, // Título que se mantiene
                summaryText: 'SleepSync', // Texto pequeño opcional abajo
              ),
            ),
          ),
          payload: link,
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