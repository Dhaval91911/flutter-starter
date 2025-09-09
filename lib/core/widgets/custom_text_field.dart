import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_template_riverpod/core/theme/extension_theme.dart';

import '../utils/text_styles.dart';
import '../utils/with_opacity_extension.dart';

class NoSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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

class CustomTextField extends ConsumerWidget {
  final double? width;
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
  final Widget? suffixIcon;
  final bool? filled;
  final Color? fillColor;
  final bool isShowBorder;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final FloatingLabelAlignment? floatingLabelAlignment;

  const CustomTextField({
    super.key,
    this.width,
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
    this.labelText,
    this.labelStyle,
    this.labelTextColor,
    this.hintText,
    this.hintStyle,
    this.hintTextColor,
    this.errorText,
    this.prefixIcon,
    this.errorMaxLines,
    this.suffixIcon,
    this.filled = true,
    this.fillColor,
    this.isShowBorder = true,
    this.borderRadius,
    this.borderColor,
    this.focusedBorderColor,
    this.floatingLabelAlignment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final customColors = ref.customColors;

    List<TextInputFormatter> inputFormatters = [
      NoSpaceInputFormatter(),
      ...(textInputFormatter ?? []),
    ];

    return IntrinsicHeight(
      child: SizedBox(
        width: width,
        child: TextFormField(
          key: ValueKey(controller),
          controller: controller,
          style:
              style ??
              TextHelper.size12(context).copyWith(
                fontWeight: FontWeight.w500,
                color: customColors.textColor, // 👈 dynamic from theme
              ),
          cursorWidth: 1.5,
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
          textCapitalization:
              textCapitalization ?? TextCapitalization.sentences,
          autovalidateMode:
              autovalidateMode ?? AutovalidateMode.onUserInteraction,
          validator: validator,
          decoration:
              decoration ??
              InputDecoration(
                isDense: true,
                isCollapsed: true,
                contentPadding:
                    contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                floatingLabelBehavior:
                    floatingLabelBehavior ?? FloatingLabelBehavior.auto,
                counterText: isShowCounterText ? null : '',
                labelText: labelText,
                labelStyle:
                    labelStyle ??
                    TextHelper.size11(context).copyWith(
                      color:
                          labelTextColor ??
                          theme.colorScheme.onSurfaceVariant
                              .withOpacityExtension(0.6),
                    ),
                floatingLabelStyle: TextHelper.size12(context).copyWith(
                  color:
                      labelTextColor ??
                      theme.colorScheme.onSurface.withOpacityExtension(0.7),
                ),
                hintText: hintText ?? '',
                hintStyle:
                    hintStyle ??
                    TextHelper.size11(context).copyWith(
                      color:
                          hintTextColor ??
                          theme.colorScheme.onSurfaceVariant
                              .withOpacityExtension(0.6),
                    ),
                floatingLabelAlignment: floatingLabelAlignment,
                errorText: errorText,
                errorMaxLines: errorMaxLines ?? 1,
                errorStyle: TextHelper.size9(context).copyWith(
                  fontWeight: FontWeight.normal,
                  color: theme.colorScheme.error,
                ),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                filled: filled,
                fillColor:
                    fillColor ??
                    customColors.opponentColor, // 👈 dynamic background
                enabledBorder: isShowBorder
                    ? OutlineInputBorder(
                        borderRadius: borderRadius ?? BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: borderColor ?? customColors.opponentColor,
                        ),
                      )
                    : InputBorder.none,
                focusedBorder: isShowBorder
                    ? OutlineInputBorder(
                        borderRadius: borderRadius ?? BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: focusedBorderColor ?? theme.primaryColor,
                        ),
                      )
                    : InputBorder.none,
                errorBorder: isShowBorder
                    ? OutlineInputBorder(
                        borderRadius: borderRadius ?? BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1,
                          color: theme.colorScheme.errorContainer,
                        ),
                      )
                    : InputBorder.none,
                focusedErrorBorder: isShowBorder
                    ? OutlineInputBorder(
                        borderRadius: borderRadius ?? BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1,
                          color: theme.colorScheme.errorContainer,
                        ),
                      )
                    : InputBorder.none,
              ),
        ),
      ),
    );
  }
}
