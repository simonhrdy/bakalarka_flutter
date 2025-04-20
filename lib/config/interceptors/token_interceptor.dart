import 'package:dio/dio.dart';

import 'package:sportmatter/domain/usecases/authorization/get_access_token_usecase.dart';

class TokenInterceptor extends InterceptorsWrapper {
  final GetAccessTokenUseCase _getAccessTokenUseCase;

  TokenInterceptor(this._getAccessTokenUseCase);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = _getAccessTokenUseCase();
    print(token);
    if (token != null) {
      options.headers.addAll({'Authorization': 'Bearer $token'});
    }
    return handler.next(options);
  }
}
