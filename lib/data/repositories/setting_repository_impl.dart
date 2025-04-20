import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportmatter/domain/entities/Setting.dart';
import 'package:sportmatter/domain/repositories/setting_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;

  SettingsRepositoryImpl(this._prefs);

  @override
  Future<bool> removeSetting(String key) async {
    return _prefs.remove(key);
  }

  @override
  Future<bool> reset() {
    return _prefs.clear();
  }

  @override
  String? getStringSetting(String key) {
    return _prefs.getString(key);
  }

  @override
  Future<bool> saveStringSetting(Setting<String> setting) {
    return _prefs.setString(setting.key, setting.value);
  }
}
