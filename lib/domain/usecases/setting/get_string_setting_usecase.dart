import 'package:sportmatter/domain/repositories/setting_repository.dart';
import 'package:sportmatter/domain/usecases/usecase.dart';

class GetStringSettingUseCase
    implements ParametrizedSyncUseCase<String?, String> {
  final SettingsRepository _settingsRepository;

  GetStringSettingUseCase(this._settingsRepository);

  @override
  String? call({required String params}) =>
      _settingsRepository.getStringSetting(params);
}
