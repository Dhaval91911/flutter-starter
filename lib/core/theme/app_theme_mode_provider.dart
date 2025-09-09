import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_template_riverpod/core/theme/app_theme.dart';

import '../../injectable/injectable.dart';
import '../shared_pref/shared_pref.dart';
import '../utils/constants.dart';

/// Holds both ThemeMode and the theme data
class AppThemeState {
  final ThemeMode mode;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  const AppThemeState({required this.mode, required this.lightTheme, required this.darkTheme});

  AppThemeState copyWith({ThemeMode? mode}) {
    return AppThemeState(mode: mode ?? this.mode, lightTheme: lightTheme, darkTheme: darkTheme);
  }
}

class AppThemeModeNotifier extends StateNotifier<AppThemeState> {
  AppThemeModeNotifier(this._prefs) : super(AppThemeState(mode: ThemeMode.system, lightTheme: AppThemes.lightTheme, darkTheme: AppThemes.darkTheme)) {
    _loadTheme();
  }

  final SharedPrefService _prefs;

  Future<void> _loadTheme() async {
    final saved = _prefs.getString(Constants.themeModeKey);
    if (saved != null) {
      final loadedMode = ThemeMode.values.firstWhere((mode) => mode.name == saved, orElse: () => ThemeMode.system);
      state = state.copyWith(mode: loadedMode);
    }
  }

  Future<void> updateTheme(ThemeMode mode) async {
    state = state.copyWith(mode: mode);
    await _prefs.setString(Constants.themeModeKey, mode.name);
  }
}

final appThemeModeProvider = StateNotifierProvider<AppThemeModeNotifier, AppThemeState>((ref) {
  return AppThemeModeNotifier(getIt<SharedPrefService>());
});
