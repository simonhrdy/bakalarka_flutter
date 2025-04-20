import 'package:sportmatter/domain/entities/Setting.dart';
import 'package:sportmatter/domain/repositories/setting_repository.dart';
import 'package:sportmatter/domain/usecases/usecase.dart';

class SaveSettingUseCase implements ParametrizedUseCase<void, Setting<String>> {
  final SettingsRepository _settingsRepository;

  SaveSettingUseCase(this._settingsRepository);

  @override
  Future<void> call({required Setting<String> params}) =>
      _settingsRepository.saveStringSetting(params);
}
