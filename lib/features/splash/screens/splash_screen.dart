import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/startup/startup_coordinator.dart';
import '../../../core/utils/text_styles.dart';
import '../../../core/utils/with_opacity_extension.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onSplashComplete();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [theme.colorScheme.primary.withOpacityExtension(0.20), theme.colorScheme.surface]
          : [theme.colorScheme.primary.withOpacityExtension(0.12), theme.colorScheme.surface],
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: baseGradient),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Premium blurred circle glows
            Positioned(top: -120.h, left: -80.w, child: _glow(theme.colorScheme.primary.withOpacityExtension(0.25), 240)),
            Positioned(bottom: -140.h, right: -100.w, child: _glow(theme.colorScheme.secondary.withOpacityExtension(0.20), 280)),

            ScaleTransition(
              scale: _scale,
              child: FadeTransition(
                opacity: _fade,
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [BoxShadow(color: theme.colorScheme.primary.withOpacityExtension(0.15), blurRadius: 32, offset: const Offset(0, 14))],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flutter_dash_rounded, size: 72.w, color: theme.primaryColor),
                      SizedBox(height: 12.h),
                      Text('Starter Template', style: TextHelper.size22(context).copyWith(fontWeight: FontWeight.w800)),
                      SizedBox(height: 6.h),
                      Text('Powered by Riverpod', style: TextHelper.size12(context).copyWith(color: theme.textTheme.bodySmall?.color)),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSplashComplete() async {
    if (!mounted) return;
    await StartupCoordinator(ref: ref, context: context).run();
  }

  Widget _glow(Color color, double size) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 120, spreadRadius: 40)],
      ),
    );
  }
}
