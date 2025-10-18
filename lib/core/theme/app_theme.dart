import 'package:flutter/material.dart';

import 'custom_theme_color.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.blue, foregroundColor: Colors.white),
    extensions: [
      CustomThemeColor(
        shimmerBaseColor: Colors.grey,
        shimmerHighlightColor: Colors.grey,
        textColor: Colors.black,
        textFiledBackGroundColor: Colors.blue,
        textFFFFFFColor: Colors.black,
        textFiledTitleColor: Color(0xff000000),
        desciptionColor: Color(0xff666666),
        opponentColor: Colors.black54,
        appUpdateColor: Colors.grey,
      ),
    ],
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    primaryColor: Colors.deepPurple,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.black, foregroundColor: Colors.white),
    extensions: [
      CustomThemeColor(
        shimmerBaseColor: Colors.grey,
        shimmerHighlightColor: Colors.grey,
        textColor: Colors.black,
        textFiledBackGroundColor: Colors.teal,
        textFFFFFFColor: Colors.black,
        textFiledTitleColor: Color(0xff000000),
        desciptionColor: Color(0xff666666),
        opponentColor: Colors.grey,
        appUpdateColor: Colors.grey,
      ),
    ],
  );
}
