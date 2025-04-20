import 'package:sportmatter/config/constants/constants.dart';
import 'package:sportmatter/domain/entities/Setting.dart';
import 'package:sportmatter/domain/usecases/setting/save_string_setting_usecase.dart';

class SaveCurrentUserUseCase {
  final SaveSettingUseCase _saveSettingUseCase;

  SaveCurrentUserUseCase(this._saveSettingUseCase);

  @override
  Future<void> call({required String params}) {
    return _saveSettingUseCase(
        params: Setting(key: kCurrentUserKey, value: params));
  }
}
