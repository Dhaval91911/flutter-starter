import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionService {
  const NotificationPermissionService();

  Future<void> requestIfNeeded() async {
    if (!(Platform.isAndroid || Platform.isIOS)) return;

    final status = await Permission.notification.status;
    if (status.isPermanentlyDenied) return; // don't loop; user must go to settings
    if (status.isDenied || status.isRestricted || status.isLimited) {
      // Await the user's choice; this will complete when the dialog is closed
      await Permission.notification.request();
    }
  }
}
