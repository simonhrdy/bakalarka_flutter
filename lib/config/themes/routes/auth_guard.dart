import 'package:auto_route/auto_route.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/domain/usecases/authorization/get_access_token_usecase.dart';

class AuthGuard extends AutoRouteGuard {
  final GetAccessTokenUseCase _getAccessTokenUseCase;

  AuthGuard(this._getAccessTokenUseCase);

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final token = _getAccessTokenUseCase();

    final isValid = token != null && token.isNotEmpty && !JwtDecoder.isExpired(token);

    if (isValid) {
      resolver.next();
    } else {
      await router.push(const LoginRoute());
    }
  }
}
