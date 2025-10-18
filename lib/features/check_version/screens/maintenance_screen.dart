import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/text_styles.dart';
import '../../../core/utils/with_opacity_extension.dart';

class MaintenanceScreen extends StatefulWidget {
  final String? maintenanceMessage;

  const MaintenanceScreen({super.key, this.maintenanceMessage});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for the icon
    _pulseController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    // Rotation animation for the gear icon
    _rotateController = AnimationController(duration: const Duration(seconds: 3), vsync: this);
    _rotateAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _rotateController, curve: Curves.linear));

    // Start animations
    _pulseController.repeat(reverse: true);
    _rotateController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false, // Prevent back button
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [theme.colorScheme.primary.withOpacityExtension(0.20), theme.colorScheme.surface]
                  : [theme.colorScheme.primary.withOpacityExtension(0.12), theme.colorScheme.surface],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated maintenance icon
                  AnimatedBuilder(
                    animation: Listenable.merge([_pulseAnimation, _rotateAnimation]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Transform.rotate(
                          angle: _rotateAnimation.value * 2 * 3.14159,
                          child: Container(
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacityExtension(0.1),
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: theme.colorScheme.primary.withOpacityExtension(0.2), blurRadius: 20, spreadRadius: 5)],
                            ),
                            child: Icon(Icons.build_rounded, size: 64.w, color: theme.colorScheme.primary),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 32.h),

                  // Title
                  Text(
                    'Under Maintenance',
                    style: TextHelper.size24(context).copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),

                  // Message
                  Text(
                    widget.maintenanceMessage ??
                        'We are currently performing scheduled maintenance to improve your experience. Please check back later.',
                    style: TextHelper.size16(context).copyWith(color: theme.colorScheme.onSurface.withOpacityExtension(0.7), height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),

                  // Progress indicator
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withOpacityExtension(0.8),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: theme.colorScheme.outline.withOpacityExtension(0.2)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary)),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'Maintenance in progress...',
                              style: TextHelper.size14(
                                context,
                              ).copyWith(color: theme.colorScheme.onSurface.withOpacityExtension(0.8), fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'We\'ll be back online shortly',
                          style: TextHelper.size12(context).copyWith(color: theme.colorScheme.onSurface.withOpacityExtension(0.6)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Contact info
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withOpacityExtension(0.5),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: theme.colorScheme.outline.withOpacityExtension(0.1)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded, size: 16.w, color: theme.colorScheme.onSurface.withOpacityExtension(0.6)),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'For urgent support, contact us at support@example.com',
                            style: TextHelper.size12(context).copyWith(color: theme.colorScheme.onSurface.withOpacityExtension(0.6)),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
