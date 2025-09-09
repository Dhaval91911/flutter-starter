import 'package:flutter/material.dart';

@immutable
class CustomThemeColor extends ThemeExtension<CustomThemeColor> {
  const CustomThemeColor({
    required this.shimmerBaseColor,
    required this.shimmerHighlightColor,
    required this.textColor,
    required this.textFiledBackGroundColor,
    required this.textFFFFFFColor,
    required this.textFiledTitleColor,
    required this.desciptionColor,
    required this.opponentColor,
    required this.appUpdateColor,
  });

  final Color shimmerBaseColor;
  final Color shimmerHighlightColor;
  final Color textColor;
  final Color textFiledBackGroundColor;
  final Color textFFFFFFColor;
  final Color textFiledTitleColor;
  final Color desciptionColor;
  final Color opponentColor;
  final Color appUpdateColor;

  @override
  CustomThemeColor copyWith({
    Color? shimmerBaseColor,
    Color? shimmerHighlightColor,
    Color? textColor,
    Color? textFiledBackGroundColor,
    Color? textFFFFFFColor,
    Color? textFiledTitleColor,
    Color? desciptionColor,
    Color? opponentColor,
    Color? appUpdateColor,
  }) {
    return CustomThemeColor(
      shimmerBaseColor: shimmerBaseColor ?? this.shimmerBaseColor,
      shimmerHighlightColor:
          shimmerHighlightColor ?? this.shimmerHighlightColor,
      textColor: textColor ?? this.textColor,
      textFiledBackGroundColor:
          textFiledBackGroundColor ?? this.textFiledBackGroundColor,
      textFFFFFFColor: textFFFFFFColor ?? this.textFFFFFFColor,
      textFiledTitleColor: textFiledTitleColor ?? this.textFiledTitleColor,
      desciptionColor: desciptionColor ?? this.desciptionColor,
      opponentColor: opponentColor ?? this.opponentColor,
      appUpdateColor: appUpdateColor ?? this.appUpdateColor,
    );
  }

  @override
  CustomThemeColor lerp(ThemeExtension<CustomThemeColor>? other, double t) {
    if (other is! CustomThemeColor) {
      return this;
    }
    return CustomThemeColor(
      shimmerBaseColor: Color.lerp(
        shimmerBaseColor,
        other.shimmerBaseColor,
        t,
      )!,
      shimmerHighlightColor: Color.lerp(
        shimmerHighlightColor,
        other.shimmerHighlightColor,
        t,
      )!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      textFiledBackGroundColor: Color.lerp(
        textFiledBackGroundColor,
        other.textFiledBackGroundColor,
        t,
      )!,
      textFFFFFFColor: Color.lerp(textFFFFFFColor, other.textFFFFFFColor, t)!,
      textFiledTitleColor: Color.lerp(
        textFiledTitleColor,
        other.textFiledTitleColor,
        t,
      )!,
      desciptionColor: Color.lerp(desciptionColor, other.desciptionColor, t)!,
      opponentColor: Color.lerp(opponentColor, other.opponentColor, t)!,
      appUpdateColor: Color.lerp(appUpdateColor, other.appUpdateColor, t)!,
    );
  }
}
