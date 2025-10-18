import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionService {
  const NotificationPermissionService();

  Future<void> requestIfNeeded() async {
    if (!(Platform.isAndroid || Platform.isIOS)) return;

    final status = await Permission.notification.status;
    if (status.isPermanentlyDenied) return; // don't loop; user must go to settings
    if (status.isDenied || status.isRestricted || status.isLimited) {
      await Permission.notification.request();
    }
  }

  /// Requests permission if needed and returns whether notifications are authorized.
  Future<bool> ensureAndIsGranted() async {
    if (!(Platform.isAndroid || Platform.isIOS)) return false;
    var status = await Permission.notification.status;
    if (status.isDenied || status.isRestricted || status.isLimited) {
      status = await Permission.notification.request();
    }
    return status.isGranted || status.isLimited;
  }
}
