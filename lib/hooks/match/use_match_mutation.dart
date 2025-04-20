import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/data/params/match/match_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/domain/repositories/api_repository.dart';
import 'package:sportmatter/hooks/inject/use_injector.dart';

(bool, Future<DataState<void>> Function(MatchParams)) useMatchMutation() {
  final isLoading = useState(false);
  final repository = useInjector<ApiRepository>();

  Future<DataState<void>> create(MatchParams params) async {
    isLoading.value = true;
    final result = await repository.createGame(params);
    isLoading.value = false;
    return result;
  }

  return (isLoading.value, create);
}
