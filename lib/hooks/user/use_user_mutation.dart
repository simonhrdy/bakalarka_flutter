import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/data/params/user/user_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/domain/repositories/api_repository.dart';
import 'package:sportmatter/hooks/inject/use_injector.dart';

(bool, Future<DataState<void>> Function(UserParams)) useRefereeMutation() {
  final isLoading = useState(false);
  final repository = useInjector<ApiRepository>();

  Future<DataState<void>> create(UserParams params) async {
    isLoading.value = true;
    final result = await repository.createUser(params);
    isLoading.value = false;
    return result;
  }

  return (isLoading.value, create);
}
