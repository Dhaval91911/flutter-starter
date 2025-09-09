import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:starter_template_riverpod/core/theme/extension_theme.dart';

import '../utils/text_styles.dart';
import '../utils/with_opacity_extension.dart';

class NoSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == ' ') {
      return oldValue;
    }
    final trimmedText = newValue.text.trimLeft();
    return TextEditingValue(
      text: trimmedText,
      selection: TextSelection.collapsed(offset: newValue.selection.baseOffset),
    );
  }
}

class CommonTextField extends ConsumerWidget {
  final TextEditingController? controller;
  final TextStyle? style;
  final Color? cursorColor;
  final Function()? onTap;
  final void Function(String?)? onSaved;
  final void Function(String)? onChange;
  final void Function(String)? onSubmitted;
  final bool? obscureText;
  final bool readOnly;
  final int? maxLength;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextDirection? textDirection;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;
  final EdgeInsetsGeometry? contentPadding;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final FloatingLabelAlignment? floatingLabelAlignment;
  final bool isShowCounterText;
  final String? labelText;
  final TextStyle? labelStyle;
  final Color? labelTextColor;
  final String? hintText;
  final TextStyle? hintStyle;
  final Color? hintTextColor;
  final String? errorText;
  final int? errorMaxLines;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final bool? filled;
  final Color? fillColor;
  final bool isShowBorder;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;

  const CommonTextField({
    super.key,
    this.controller,
    this.style,
    this.cursorColor,
    this.onTap,
    this.onSaved,
    this.onChange,
    this.onSubmitted,
    this.obscureText,
    this.readOnly = false,
    this.maxLength,
    this.maxLines,
    this.keyboardType,
    this.textDirection,
    this.textInputFormatter,
    this.textInputAction,
    this.textCapitalization,
    this.autovalidateMode,
    this.validator,
    this.decoration,
    this.contentPadding,
    this.floatingLabelBehavior,
    this.isShowCounterText = false,
    this.floatingLabelAlignment,
    this.labelText,
    this.labelStyle,
    this.labelTextColor,
    this.hintText,
    this.hintStyle,
    this.hintTextColor,
    this.errorText,
    this.errorMaxLines,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.filled = true,
    this.fillColor,
    this.isShowBorder = true,
    this.borderRadius,
    this.borderColor,
    this.focusedBorderColor,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final isDark = theme.brightness == Brightness.dark;

    List<TextInputFormatter>? inputFormatters = [NoSpaceInputFormatter(), ...(textInputFormatter ?? [])];

    Widget field = TextFormField(
      key: ValueKey(controller),
      controller: controller,
      style: style ?? TextHelper.size14(context).copyWith(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.grey.shade800),
      cursorWidth: 1,
      cursorRadius: const Radius.circular(10),
      cursorColor: cursorColor ?? theme.primaryColor,
      autofocus: false,
      enableSuggestions: true,
      onTap: onTap,
      onSaved: onSaved,
      onChanged: onChange,
      onFieldSubmitted: onSubmitted,
      obscureText: obscureText ?? false,
      textAlignVertical: TextAlignVertical.center,
      readOnly: readOnly,
      maxLength: maxLength,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      textDirection: textDirection,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction ?? TextInputAction.done,
      textCapitalization: textCapitalization ?? TextCapitalization.sentences,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      validator: validator,
      decoration:
          decoration ??
          InputDecoration(
            isDense: true,
            isCollapsed: true,
            contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            floatingLabelBehavior: floatingLabelBehavior ?? FloatingLabelBehavior.auto,
            counterText: isShowCounterText ? null : '',
            labelText: labelText,
            labelStyle:
                labelStyle ??
                TextHelper.size12(context).copyWith(fontWeight: FontWeight.w500, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            floatingLabelStyle: TextHelper.size12(
              context,
            ).copyWith(fontWeight: FontWeight.w500, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            hintText: hintText ?? '',
            hintStyle:
                hintStyle ??
                TextHelper.size12(context).copyWith(fontWeight: FontWeight.w500, color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
            floatingLabelAlignment: floatingLabelAlignment,
            errorText: errorText,
            errorMaxLines: errorMaxLines ?? 1,
            errorStyle: TextHelper.size11(context).copyWith(fontWeight: FontWeight.w500, color: theme.colorScheme.error),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 16.w, top: 12.h, right: 10.w, bottom: 12.h),
              child: prefixIcon,
            ),
            prefixIconConstraints:
                prefixIconConstraints ?? BoxConstraints(minWidth: prefixIcon != null ? 24 : 0, minHeight: prefixIcon != null ? 24 : 0),
            suffixIcon: suffixIcon,
            suffixIconConstraints:
                suffixIconConstraints ?? BoxConstraints(minWidth: suffixIcon != null ? 24 : 0, minHeight: suffixIcon != null ? 24 : 0),
            filled: filled,
            fillColor: fillColor ?? (theme.brightness == Brightness.dark ? theme.colorScheme.surface.withOpacityExtension(0.14) : Colors.white),
            border: isShowBorder
                ? border ??
                      OutlineInputBorder(
                        borderRadius: borderRadius ?? BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: isDark ? Colors.grey.shade700.withOpacityExtension(0.3) : Colors.grey.shade200, width: 1),
                      )
                : InputBorder.none,
            enabledBorder: isShowBorder
                ? enabledBorder ??
                      OutlineInputBorder(
                        borderRadius: borderRadius ?? BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: isDark ? Colors.grey.shade700.withOpacityExtension(0.3) : Colors.grey.shade200, width: 1),
                      )
                : InputBorder.none,
            focusedBorder: isShowBorder
                ? focusedBorder ??
                      OutlineInputBorder(
                        borderRadius: borderRadius ?? BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: theme.primaryColor, width: 2),
                      )
                : InputBorder.none,
            errorBorder: isShowBorder
                ? errorBorder ??
                      OutlineInputBorder(
                        borderRadius: borderRadius ?? BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
                      )
                : InputBorder.none,
            focusedErrorBorder: isShowBorder
                ? focusedErrorBorder ??
                      OutlineInputBorder(
                        borderRadius: borderRadius ?? BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
                      )
                : InputBorder.none,
          ),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12.r),
        color: isDark ? Colors.grey.shade800.withOpacityExtension(0.3) : Colors.white,
      ),
      alignment: Alignment.center,
      child: field,
    );
  }
}
