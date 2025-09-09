import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_theme_mode_provider.dart';
import 'custom_theme_color.dart';

final systemBrightnessProvider = StreamProvider<Brightness>((ref) async* {
  final dispatcher = WidgetsBinding.instance.platformDispatcher;

  // Emit the current brightness first
  yield dispatcher.platformBrightness;

  // Then keep emitting when brightness changes
  final controller = StreamController<Brightness>();

  void listener() {
    controller.add(dispatcher.platformBrightness);
  }

  dispatcher.onPlatformBrightnessChanged = listener;

  // Cleanup when provider is disposed
  ref.onDispose(() {
    controller.close();
    dispatcher.onPlatformBrightnessChanged = null;
  });

  yield* controller.stream;
});

final themeProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(appThemeModeProvider);
  final systemBrightnessAsync = ref.watch(systemBrightnessProvider);

  final systemBrightness = systemBrightnessAsync.value ?? Brightness.light;

  if (themeMode.mode == ThemeMode.dark) {
    return themeMode.darkTheme;
  } else if (themeMode.mode == ThemeMode.light) {
    return themeMode.lightTheme;
  } else {
    return systemBrightness == Brightness.dark
        ? themeMode.darkTheme
        : themeMode.lightTheme;
  }
});

extension ThemeRefX on WidgetRef {
  ThemeData get theme => watch(themeProvider);
  CustomThemeColor get customColors => theme
      .extension<CustomThemeColor>()!; // Use ! if you're sure it's non-null

  Color get primaryColor => theme.primaryColor;
  Color get accentColor => theme.colorScheme.secondary;
  TextTheme get textTheme => theme.textTheme;
  Color get backGround => customColors.textFiledBackGroundColor;
  Color get opponentColor => customColors.opponentColor;
}
