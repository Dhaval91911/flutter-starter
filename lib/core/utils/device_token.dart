import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'logger.dart';

class DeviceInfoService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<String?> getDeviceToken() async {
    try {
      if (Platform.isIOS) {
        final apnsToken = await _messaging.getAPNSToken();
        AppLogger.info('APNS Token => $apnsToken');
      }
      final fcmToken = await _messaging.getToken();
      AppLogger.info('FCM Token => $fcmToken');
      return fcmToken;
    } catch (e, st) {
      AppLogger.error('Failed to fetch FCM token', 'DeviceInfoService', e, st);
      return null;
    }
  }
}
