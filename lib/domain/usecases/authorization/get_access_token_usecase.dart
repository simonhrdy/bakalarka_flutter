import 'package:sportmatter/config/constants/constants.dart';
import 'package:sportmatter/domain/usecases/setting/get_string_setting_usecase.dart';
import 'package:sportmatter/domain/usecases/usecase.dart';

class GetAccessTokenUseCase implements SimpleSyncUseCase<String?> {
  final GetStringSettingUseCase _getSettingUseCase;

  GetAccessTokenUseCase(this._getSettingUseCase);

  @override
  String? call() => _getSettingUseCase(params: kTokenKey);
}
