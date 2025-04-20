import 'package:sportmatter/domain/entities/Setting.dart';

abstract class SettingsRepository {
  Future<bool> saveStringSetting(Setting<String> setting);

  String? getStringSetting(String key);

  Future<bool> removeSetting(String key);

  Future<bool> reset();
}
