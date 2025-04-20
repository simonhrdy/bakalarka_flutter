import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/data/params/stadium/stadium_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/domain/repositories/api_repository.dart';
import 'package:sportmatter/hooks/inject/use_injector.dart';

(bool, Future<DataState<void>> Function(StadiumParams)) useStadiumMutation() {
  final isLoading = useState(false);
  final repository = useInjector<ApiRepository>();

  Future<DataState<void>> create(StadiumParams params) async {
    isLoading.value = true;
    final result = await repository.createStadium(params);
    isLoading.value = false;
    return result;
  }

  return (isLoading.value, create);
}
