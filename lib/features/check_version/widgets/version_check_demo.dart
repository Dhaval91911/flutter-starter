import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/text_styles.dart';
import '../../../core/utils/with_opacity_extension.dart';
import '../../../core/widgets/common_primary_button.dart';
import '../../../core/widgets/dialogs/update_dialog.dart';
import '../screens/maintenance_screen.dart';
import '../state_notifier/version_notifier.dart';

/// Demo widget to test different version check scenarios
/// This can be used for testing purposes or removed in production
class VersionCheckDemo extends ConsumerWidget {
  const VersionCheckDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Version Check Demo'), backgroundColor: theme.colorScheme.surface),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Test Version Check Scenarios', style: TextHelper.size20(context).copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 24.h),

            // Test Optional Update
            CommonPrimaryButton(label: 'Test Optional Update', onPressed: () => _testOptionalUpdate(context)),
            SizedBox(height: 12.h),

            // Test Force Update
            CommonPrimaryButton(label: 'Test Force Update', onPressed: () => _testForceUpdate(context)),
            SizedBox(height: 12.h),

            // Test Maintenance Mode
            CommonPrimaryButton(label: 'Test Maintenance Mode', onPressed: () => _testMaintenanceMode(context)),
            SizedBox(height: 12.h),

            // Test Real API Call
            CommonPrimaryButton(label: 'Test Real API Call', onPressed: () => _testRealApiCall(context, ref)),
            SizedBox(height: 24.h),

            Text(
              'Note: This demo widget is for testing purposes only. Remove in production.',
              style: TextHelper.size12(context).copyWith(color: theme.colorScheme.onSurface.withOpacityExtension(0.6), fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _testOptionalUpdate(BuildContext context) {
    UpdateDialog.show(context: context, isForceUpdate: false, updateMessage: 'A new version of the app is available. Would you like to update now?');
  }

  void _testForceUpdate(BuildContext context) {
    UpdateDialog.show(
      context: context,
      isForceUpdate: true,
      updateMessage: 'A new version of the app is available. Please update to continue using the app.',
    );
  }

  void _testMaintenanceMode(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MaintenanceScreen(
          maintenanceMessage: 'We are currently performing scheduled maintenance to improve your experience. Please check back later.',
        ),
      ),
    );
  }

  void _testRealApiCall(BuildContext context, WidgetRef ref) {
    ref.read(versionNotifierProvider.notifier).setContext(context);
    ref.read(versionNotifierProvider.notifier).checkVersion();
  }
}
