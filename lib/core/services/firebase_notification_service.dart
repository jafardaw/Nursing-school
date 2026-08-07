// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';

// class FirebaseNotificationService {
//   FirebaseNotificationService._();

//   static final FirebaseNotificationService instance =
//       FirebaseNotificationService._();

//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;

//   // الصق هنا Web Push certificate من Firebase Console.
//   static const String _webVapidKey =
//       'BAyvHUDHV3GgM5tDTwRRSRWrDDdK3b0ftdZS1BWNVuLvJ-PTk1hVJgcny09tdGduqx8aw4daGH88TID-4yLFpoI';

//   void initializeListeners() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint('--- Foreground FCM Message ---');
//       debugPrint('Title: ${message.notification?.title}');
//       debugPrint('Body: ${message.notification?.body}');
//       debugPrint('Data: ${message.data}');
//     });

//     _messaging.onTokenRefresh.listen((newToken) {
//       debugPrint('--- FCM Token Refreshed ---');
//       debugPrint(newToken);

//       // لاحقًا: أرسل التوكن الجديد إلى الـ Backend.
//     });
//   }

//   Future<String?> enableNotifications() async {
//     if (!kIsWeb) {
//       return null;
//     }

//     final settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     final isAllowed =
//         settings.authorizationStatus == AuthorizationStatus.authorized ||
//         settings.authorizationStatus == AuthorizationStatus.provisional;

//     if (!isAllowed) {
//       debugPrint('Notification permission was denied');
//       return null;
//     }

//     final token = await _messaging.getToken(vapidKey: _webVapidKey);

//     debugPrint('--- FCM WEB TOKEN ---');
//     debugPrint(token);

//     return token;
//   }
// }
