import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:starter_template_riverpod/core/utils/with_opacity_extension.dart';

SizedBox height(double h) => SizedBox(height: h);

SizedBox width(double w) => SizedBox(width: w);

// Show progress indicator
showProgressIndicator() {
  final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
  final isDark = brightness == Brightness.dark;
  EasyLoading.instance
    ..indicatorColor = isDark ? Colors.black : Colors.white
    ..textColor = isDark ? Colors.black : Colors.white
    ..backgroundColor = isDark ? Colors.white : const Color(0xCC000000)
    ..maskColor = isDark ? Colors.black.withOpacityExtension(0.2) : Colors.black.withOpacityExtension(0.1)
    ..indicatorType = EasyLoadingIndicatorType.circle;

  return EasyLoading.show(maskType: EasyLoadingMaskType.custom, status: 'Loading', dismissOnTap: false);
}

// Dismiss progress indicator
dismissProgressIndicator() {
  return EasyLoading.dismiss();
}

// Stop for going back
void onPopInvoked(didPop) async {
  if (didPop) {
    return;
  }
  if (EasyLoading.isShow) {
    return;
  }
}
