import 'package:injectable/injectable.dart' as i;
import 'package:shared_preferences/shared_preferences.dart';

abstract class SaveMethod {
  // String
  Future<bool> setString(String key, String value);
  String? getString(String key);

  // Bool
  Future<bool> setBool(String key, bool value);
  bool? getBool(String key);

  // Int
  Future<bool> setInt(String key, int value);
  int? getInt(String key);

  // Double
  Future<bool> setDouble(String key, double value);
  double? getDouble(String key);

  // String List
  Future<bool> setStringList(String key, List<String> value);
  List<String>? getStringList(String key);

  // Remove
  Future<bool> remove(String key);

  // Clear All
  Future<bool> clear();
}

@i.lazySingleton
@i.injectable
class SharedPrefService implements SaveMethod {
  final SharedPreferences pref;

  SharedPrefService({required this.pref});

  // ------------------ String ------------------
  @override
  Future<bool> setString(String key, String value) =>
      pref.setString(key, value);

  @override
  String? getString(String key) => pref.getString(key);

  // ------------------ Bool ------------------
  @override
  Future<bool> setBool(String key, bool value) => pref.setBool(key, value);

  @override
  bool? getBool(String key) => pref.getBool(key);

  // ------------------ Int ------------------
  @override
  Future<bool> setInt(String key, int value) => pref.setInt(key, value);

  @override
  int? getInt(String key) => pref.getInt(key);

  // ------------------ Double ------------------
  @override
  Future<bool> setDouble(String key, double value) =>
      pref.setDouble(key, value);

  @override
  double? getDouble(String key) => pref.getDouble(key);

  // ------------------ String List ------------------
  @override
  Future<bool> setStringList(String key, List<String> value) =>
      pref.setStringList(key, value);

  @override
  List<String>? getStringList(String key) => pref.getStringList(key);

  // ------------------ Remove ------------------
  @override
  Future<bool> remove(String key) => pref.remove(key);

  // ------------------ Clear ------------------
  @override
  Future<bool> clear() => pref.clear();
}
