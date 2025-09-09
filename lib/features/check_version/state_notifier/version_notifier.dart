import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_template_riverpod/features/check_version/model/check_version_model.dart';
import 'package:starter_template_riverpod/features/check_version/model/check_version_req_model.dart';

import '../../../core/widgets/custome_toast.dart';
import '../../../injectable/injectable.dart';
import '../../../services/web_service/api_service.dart';

final versionNotifierProvider = StateNotifierProvider.autoDispose<VersionNotifier, AsyncValue<CheckAppVersionModel>>((ref) {
  return getIt<VersionNotifier>();
});

@injectable
class VersionNotifier extends StateNotifier<AsyncValue<CheckAppVersionModel>> {
  final ApiService apiService;

  VersionNotifier(this.apiService) : super(const AsyncValue.loading());

  Future<void> checkVersion() async {
    try {
      state = const AsyncValue.loading();

      final body = CheckVersionRequest(appVersion: '1.0.0', appPlatform: 'android', selectedLanguage: 'en');

      final data = await apiService.checkVersion(body);
      state = AsyncValue.data(data);
      showStyledToast('Version check successful', ToastType.success);
      handleSheet(data);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      showStyledToast('Version check failed', ToastType.error);
    }
  }

  void handleSheet(CheckAppVersionModel data) {
    // Handle the version check response
    // This could show a dialog, navigate to update page, etc.
    if (data.data.isNeedUpdate) {
      // Show update dialog or navigate to update screen
      // Example: showUpdateDialog(data);
    } else {
      // App is up to date
      // Example: showUpToDateMessage();
    }
  }
}
