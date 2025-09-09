import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceInfoService {
  Future<String?> getDeviceToken() async {
    return await FirebaseMessaging.instance.getToken();
  }
}
