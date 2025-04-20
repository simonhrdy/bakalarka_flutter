import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/data/models/login/login_model.dart';
import 'package:sportmatter/data/params/login/login_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/domain/usecases/save_current_user_usecase.dart';
import 'package:sportmatter/domain/usecases/save_token_usecase.dart';
import 'package:sportmatter/hooks/inject/use_injector.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';

(bool, Future<DataState<LoginModel>> Function(LoginParams)) useLoginMutation() {
  final isPendingState = useState(false);
  final repository = useApiRepository();

  final apiRepository = useApiRepository();
  final saveCurrentUserUseCase = useInjector<SaveCurrentUserUseCase>();
  final saveTokenUseCase = useInjector<SaveTokenUsecase>();

  return (
  isPendingState.value,
      (LoginParams params) async {
    isPendingState.value = true;

    final state = await apiRepository.login(params);

    final token = state.data?.token;

    if (state is DataSuccess && token != null) {
      final user = await repository.getCurrentUser(token: token);
      final roles = user.data?.roles ?? [];

      final allowedRoles = ['ROLE_MANAGER', 'ROLE_SUPERADMIN', 'ROLE_REDACTOR'];
      final hasOnlyUserRole = roles.length == 1 && roles.contains('ROLE_USER');
      final hasAnyAllowedRole = roles.any(allowedRoles.contains);

      if (hasOnlyUserRole || !hasAnyAllowedRole) {
        isPendingState.value = false;
        return DataFailed(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.unknown,
            error: 'Unauthorized role',
          ),
        );
      }


      await saveTokenUseCase(params: token);
      await saveCurrentUserUseCase(
        params: jsonEncode(user.data?.toJson()),
      );

      isPendingState.value = false;
      return state;
    }

    isPendingState.value = false;
    return state;
  }
  );
}

