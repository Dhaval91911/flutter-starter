import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotificationHandler {
  /// Initializes local and Firebase notification handlers and call in main.dart
  static Future<void> initialize() async {
    // Firebase Initialization
    await Firebase.initializeApp();

    // Set up Firebase message handlers
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(handleForegroundNotification);

    // Request iOS notification permissions
    await _requestIOSPermissions();

    // Log the FCM token
    String? token = await FirebaseMessaging.instance.getToken();
    log('FCM Token: $token');
  }

  /// Handles background notifications
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    debugPrint('Background notification: ${message.notification?.title}');
  }

  /// Handles foreground notifications
  static void handleForegroundNotification(RemoteMessage message) {
    debugPrint('Foreground notification: ${message.notification?.title}');
    sendNotification(
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      message.notification?.android?.imageUrl ?? '',
      message.data,
    );
  }

  static Future<void> sendNotification(
    String title,
    String body,
    String? imageUrl,
    Map<String, dynamic> payload,
  ) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: true,
            requestSoundPermission: true,
            requestBadgePermission: true,
            // onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
          ),
        );

    /// App foreground to tap notification to redirect screen
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('Notification tapped: ${response.payload}');
      },
    );

    if (Platform.isIOS) {
      // Request iOS permissions explicitly
      final iOSFlutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final granted = await iOSFlutterLocalNotificationsPlugin
          ?.requestPermissions(alert: true, badge: true, sound: true);
      log('iOS Notification permissions granted: $granted');
    }

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'default_channel', // Use the same channel ID
          'Default Notifications',
          channelDescription: 'This channel is used for default notifications.',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          icon: '@mipmap/launcher_icon',
        );

    DarwinNotificationDetails iOSNotificationDetails =
        const DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
          presentBadge: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // Notification ID
      title, // Dynamic title
      body, // Dynamic body
      notificationDetails,
      payload: jsonEncode(payload),
    );
  }

  static Future<void> notificationGet() async {
    RemoteMessage? initMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initMessage != null) {}

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('Notification tapped: ${message.data}');
    });
  }

  static Future<void> _requestIOSPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
    );

    log('iOS Permission Status: ${settings.authorizationStatus}');
  }
}
