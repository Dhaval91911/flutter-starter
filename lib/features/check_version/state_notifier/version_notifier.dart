import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_template_riverpod/core/widgets/dialogs/update_dialog.dart';
import 'package:starter_template_riverpod/features/check_version/model/check_version_model.dart';
import 'package:starter_template_riverpod/features/check_version/model/check_version_req_model.dart';
import 'package:starter_template_riverpod/route_config/route_config.dart';
import 'package:starter_template_riverpod/route_config/routes.dart';

import '../../../core/shared_pref/shared_pref.dart';
import '../../../core/shared_pref/storage_keys.dart';
import '../../../core/widgets/custome_toast.dart';
import '../../../injectable/injectable.dart';
import '../../../services/web_service/api_service.dart';

final versionNotifierProvider = StateNotifierProvider<VersionNotifier, AsyncValue<CheckAppVersionModel>>((ref) {
  return getIt<VersionNotifier>();
});

@injectable
class VersionNotifier extends StateNotifier<AsyncValue<CheckAppVersionModel>> {
  final ApiService apiService;
  final SharedPrefService _prefs;
  BuildContext? _context;
  bool _blockNavigation = false;
  bool _dialogShown = false;

  VersionNotifier(this.apiService, [SharedPrefService? prefs]) : _prefs = prefs ?? getIt<SharedPrefService>(), super(const AsyncValue.loading());

  void setContext(BuildContext context) {
    _context = context;
  }

  bool get blockNavigation => _blockNavigation;
  bool get dialogShown => _dialogShown;

  Future<CheckAppVersionModel?> checkVersion() async {
    try {
      state = const AsyncValue.loading();

      final body = CheckVersionRequest(appVersion: '1.0.0', appPlatform: 'android', selectedLanguage: 'en');

      final data = await apiService.checkVersion(body);
      state = AsyncValue.data(data);

      // Persist static content for later use
      await _prefs.setString(StorageKeys.appTerms, data.data.termsAndConditions);
      await _prefs.setString(StorageKeys.appPrivacy, data.data.privacyPolicy);
      await _prefs.setString(StorageKeys.appAbout, data.data.about);

      // Handle different update scenarios
      await _handleVersionResponse(data);

      return data;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      showStyledToast('Version check failed', ToastType.error);
      return null;
    }
  }

  Future<void> _handleVersionResponse(CheckAppVersionModel data) async {
    if (_context == null) return;

    // Priority 1: Maintenance mode - highest priority
    if (data.data.isMaintenance) {
      _blockNavigation = true;
      AppRouter.router.go(
        Routes.maintenance,
        extra: {'message': 'We are currently performing scheduled maintenance to improve your experience. Please check back later.'},
      );
      return;
    }

    // Priority 2: Force update - user cannot proceed without updating
    if (data.data.isForceUpdate) {
      _blockNavigation = true;
      if (_context != null && !_dialogShown) {
        _dialogShown = true;
        await UpdateDialog.show(
          context: _context!,
          isForceUpdate: true,
          updateMessage: 'A new version of the app is available. Please update to continue using the app.',
        );
      }
      return;
    }

    // Priority 3: Optional update - user can choose to update or continue
    if (data.data.isNeedUpdate) {
      _blockNavigation = false;
      if (_context != null && !_dialogShown) {
        _dialogShown = true;
        await UpdateDialog.show(
          context: _context!,
          isForceUpdate: false,
          updateMessage: 'A new version of the app is available. Would you like to update now?',
        );
      }
      return;
    }

    // App is up to date - continue with normal flow
    _blockNavigation = false;
  }

  // Legacy method for backward compatibility
  void handleSheet(CheckAppVersionModel data) {
    _handleVersionResponse(data);
  }
}
