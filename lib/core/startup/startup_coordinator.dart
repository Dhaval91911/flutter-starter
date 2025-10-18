import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/notifier/auth_notifier.dart';
import '../../features/check_version/notifier/version_notifier.dart';
import '../../route_config/route_config.dart';
import '../../route_config/routes.dart';
import '../../services/permissions/notification_permission_service.dart';
import '../utils/logger.dart';

class StartupCoordinator {
  final WidgetRef ref;
  final BuildContext context;
  // Use existing static AppLogger methods

  StartupCoordinator({required this.ref, required this.context});

  Future<void> run() async {
    try {
      ref.read(versionNotifierProvider.notifier).setContext(context);
      await ref.read(versionNotifierProvider.notifier).checkVersion();
      if (ref.read(versionNotifierProvider.notifier).blockNavigation) return;
    } catch (e, st) {
      AppLogger.warning('Version check failed; continuing startup', 'StartupCoordinator');
      AppLogger.error('Version check error', 'StartupCoordinator', e, st);
    }

    try {
      await const NotificationPermissionService().requestIfNeeded();
    } catch (e, st) {
      AppLogger.warning('Notification permission failed', 'StartupCoordinator');
      AppLogger.error('Permission error', 'StartupCoordinator', e, st);
    }

    try {
      final auth = ref.read(authNotifierProvider.notifier);
      final isLoggedIn = await auth.isUserLoggedIn();
      if (isLoggedIn) {
        await auth.loadStoredUser();
        AppRouter.router.go(Routes.dashboard);
      } else {
        AppRouter.router.go(Routes.login);
      }
    } catch (e, st) {
      AppLogger.error('Auth preload failed, routing to login', 'StartupCoordinator', e, st);
      AppRouter.router.go(Routes.login);
    }
  }
}
