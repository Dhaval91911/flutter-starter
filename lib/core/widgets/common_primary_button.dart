import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/with_opacity_extension.dart';

class CommonPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;

  const CommonPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null || isLoading;
    final buttonColor = backgroundColor ?? theme.primaryColor;
    final buttonTextColor = textColor ?? Colors.white;

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Container(
        padding: padding ?? EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((borderRadius ?? 12).r),
          color: buttonColor,
          boxShadow: isDisabled ? null : [BoxShadow(color: buttonColor.withOpacityExtension(0.3), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(buttonTextColor)),
                )
              : Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: buttonTextColor, fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }
}
