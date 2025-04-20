import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/data/params/changePassword/change_password_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/domain/repositories/api_repository.dart';
import 'package:sportmatter/hooks/inject/use_injector.dart';

(bool, Future<DataState<void>> Function(int, ChangePasswordParams)) useChangePasswordMutation() {
  final isLoading = useState(false);
  final repository = useInjector<ApiRepository>();

  Future<DataState<void>> changePassword(int userId, ChangePasswordParams params) async {
    isLoading.value = true;
    final result = await repository.changePassword(userId, params);
    isLoading.value = false;
    return result;
  }

  return (isLoading.value, changePassword);
}
