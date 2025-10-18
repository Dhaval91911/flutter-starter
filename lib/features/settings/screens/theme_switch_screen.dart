import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme_mode_provider.dart';
import '../../../generated/locale_keys.g.dart';

class ThemeSwitchScreen extends ConsumerWidget {
  const ThemeSwitchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(appThemeModeProvider);
    final themeNotifier = ref.read(appThemeModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.setting.tr())),
      body: ListView(
        children: ThemeMode.values.map((mode) {
          return RadioListTile<ThemeMode>(
            title: Text(
              (mode.name[0].toUpperCase() + mode.name.substring(1)).tr(),
            ),
            value: mode,
            groupValue: themeState.mode,
            onChanged: (value) {
              if (value != null) {
                themeNotifier.updateTheme(value);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
