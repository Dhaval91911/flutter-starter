import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../firebase_options.dart';

/// Single instance to manage local notifications
final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

/// Default Android notification channel
const AndroidNotificationChannel _defaultChannel = AndroidNotificationChannel(
  'default_channel',
  'Default Notifications',
  description: 'This channel is used for default notifications.',
  importance: Importance.high,
);

/// Top-level background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase must be initialized in background isolate
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (_) {}

  // Avoid double notifications: if FCM includes a notification payload, Android will
  // show it automatically in background/terminated states. Only show local for data-only.
  if (message.notification == null) {
    await _showRemoteMessageAsLocalNotification(message);
  }
}

class AppNotificationHandler {
  /// Call once during app startup (after Firebase.initializeApp)
  static Future<void> initialize() async {
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Create Android notification channel and initialize plugin
    await _initializeLocalNotifications();

    // Android 13+ notification permission
    await _requestAndroidPermissionsIfNeeded();

    // iOS/macOS permission
    await _requestApplePermissions();

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_onMessage);

    // App opened from background via notification tap
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // App launched from terminated via notification tap
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationNavigation(initialMessage);
    }

    // Token debug
    final token = await FirebaseMessaging.instance.getToken();
    log('FCM Token: $token');
  }
}

Future<void> _initializeLocalNotifications() async {
  const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(requestAlertPermission: true, requestSoundPermission: true, requestBadgePermission: true),
  );

  await _localNotifications.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      log('Notification tapped: ${response.payload}');
      // Payload handling for deep links can be added here if needed
    },
  );

  // Create Android channel
  final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.createNotificationChannel(_defaultChannel);
}

Future<void> _requestAndroidPermissionsIfNeeded() async {
  if (!Platform.isAndroid) return;
  final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  try {
    await androidPlugin?.requestNotificationsPermission();
  } catch (_) {}
}

Future<void> _requestApplePermissions() async {
  if (!Platform.isIOS && !Platform.isMacOS) return;
  final settings = await FirebaseMessaging.instance.requestPermission(alert: true, announcement: true, badge: true, sound: true);
  log('Apple notification permission: ${settings.authorizationStatus}');
}

void _onMessage(RemoteMessage message) {
  debugPrint('Foreground notification: ${message.notification?.title}');
  // Foreground: Android/iOS do not display system notifications automatically.
  // Show local notification for both notification and data-only messages.
  _showRemoteMessageAsLocalNotification(message);
}

void _onMessageOpenedApp(RemoteMessage message) {
  debugPrint('Notification opened from background: ${message.data}');
  _handleNotificationNavigation(message);
}

Future<void> _showRemoteMessageAsLocalNotification(RemoteMessage message) async {
  final title = message.notification?.title ?? (message.data['title']?.toString() ?? '');
  final body = message.notification?.body ?? (message.data['body']?.toString() ?? '');
  final payload = jsonEncode(message.data);

  final details = NotificationDetails(
    android: AndroidNotificationDetails(
      _defaultChannel.id,
      _defaultChannel.name,
      channelDescription: _defaultChannel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    ),
    iOS: const DarwinNotificationDetails(presentAlert: true, presentSound: true, presentBadge: true),
  );

  await _localNotifications.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title.isEmpty ? 'Notification' : title,
    body.isEmpty ? null : body,
    details,
    payload: payload,
  );
}

void _handleNotificationNavigation(RemoteMessage message) {
  // Implement deep link/navigation using message.data if required
  // e.g., use a global navigator key or a routing service
}
