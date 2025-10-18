import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/text_styles.dart';
import '../../utils/with_opacity_extension.dart';
import '../common_primary_button.dart';

class UpdateDialog extends StatelessWidget {
  final bool isForceUpdate;
  final String? updateMessage;

  const UpdateDialog({super.key, required this.isForceUpdate, this.updateMessage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: !isForceUpdate, // Prevent back button if force update
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [BoxShadow(color: theme.colorScheme.primary.withOpacityExtension(0.1), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Update Icon
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacityExtension(0.1), shape: BoxShape.circle),
                child: Icon(Icons.system_update_rounded, size: 32.w, color: theme.colorScheme.primary),
              ),
              SizedBox(height: 16.h),

              // Title
              Text(
                isForceUpdate ? 'Update Required' : 'Update Available',
                style: TextHelper.size20(context).copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),

              // Message
              Text(
                updateMessage ??
                    (isForceUpdate
                        ? 'A new version of the app is available. Please update to continue using the app.'
                        : 'A new version of the app is available. Would you like to update now?'),
                style: TextHelper.size14(context).copyWith(color: theme.colorScheme.onSurface.withOpacityExtension(0.7)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              // Buttons
              Row(
                children: [
                  if (!isForceUpdate) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          side: BorderSide(color: theme.colorScheme.outline.withOpacityExtension(0.3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                        child: Text(
                          'Later',
                          style: TextHelper.size14(
                            context,
                          ).copyWith(color: theme.colorScheme.onSurface.withOpacityExtension(0.7), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                  ],
                  Expanded(
                    child: CommonPrimaryButton(label: 'Update Now', onPressed: () => _launchAppStore(context), borderRadius: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchAppStore(BuildContext context) async {
    try {
      // For Android - Google Play Store
      const androidUrl = 'https://play.google.com/store/apps/details?id=com.example.starter_template_riverpod';
      // For iOS - App Store
      const iosUrl = 'https://apps.apple.com/app/id1234567890'; // Replace with actual App Store ID

      final Uri url = Uri.parse(Theme.of(context).platform == TargetPlatform.iOS ? iosUrl : androidUrl);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not open app store'), backgroundColor: Theme.of(context).colorScheme.error));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error opening app store: $e'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    }
  }

  static Future<bool?> show({required BuildContext context, required bool isForceUpdate, String? updateMessage}) {
    return showDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: !isForceUpdate, // Prevent dismissing if force update
      builder: (context) => UpdateDialog(isForceUpdate: isForceUpdate, updateMessage: updateMessage),
    );
  }
}
