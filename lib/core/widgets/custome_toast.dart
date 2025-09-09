import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

import '../../generated/assets.gen.dart';

enum ToastType { success, error, warning, info }

Widget buildCustomToast(String message, ToastType type) {
  final iconData = {
    ToastType.success: Assets.png.success.image(),
    ToastType.error: Assets.png.error.image(),
    ToastType.warning: Assets.png.warning.image(),
    ToastType.info: Assets.png.info.image(),
  };

  final bgColor = {
    ToastType.success: const Color(0xffE0FFFC),
    ToastType.error: const Color(0xFFFFEBE6),
    ToastType.warning: const Color(0xFFDAEAFF),
    ToastType.info: const Color(0xFFFFFBF5),
  };

  final borderColor = {
    ToastType.success: const Color(0xff48C1B5),
    ToastType.error: const Color(0xFFF4B0A1),
    ToastType.warning: const Color(0xFF9DC0EE),
    ToastType.info: const Color(0xFfF7D9A4),
  };

  final testColor = {
    ToastType.success: const Color(0xff224845),
    ToastType.error: const Color(0xFF634C46),
    ToastType.warning: const Color(0xFF464E58),
    ToastType.info: const Color(0xFf504535),
  };

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 15.w),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor[type]!, width: 1.3),
        color: bgColor[type],
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 24.sp, width: 24.sp, child: iconData[type]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              message,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: testColor[type],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void showStyledToast(String message, ToastType type) {
  showToastWidget(
    buildCustomToast(message, type),
    position: ToastPosition.bottom,
    duration: const Duration(seconds: 3),
    dismissOtherToast: true,
    animationCurve: Curves.easeInOut,
    animationDuration: const Duration(milliseconds: 300),
  );
}
