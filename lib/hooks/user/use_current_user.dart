import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/constants/constants.dart';
import 'package:sportmatter/domain/usecases/setting/get_string_setting_usecase.dart';
import 'package:sportmatter/hooks/inject/use_injector.dart';
import 'package:sportmatter/data/models/user/user_model.dart';

UserModel? useCurrentUser() {
  final state = useState<UserModel?>(null);
  final getStringSettingUseCase = useInjector<GetStringSettingUseCase>();

  useEffect(() {
    Future<void> loadUser() async {
      final raw = getStringSettingUseCase(params: kCurrentUserKey);
      if (raw != null) {
        try {
          final json = jsonDecode(raw) as Map<String, dynamic>;
          state.value = UserModel.fromJson(json);
        } catch (e) {
          print('Error decoding user: $e');
          state.value = null;
        }
      }
    }

    loadUser();
    return null;
  }, []);

  return state.value;
}
