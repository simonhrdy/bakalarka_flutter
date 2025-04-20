import 'package:auto_route/auto_route.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/domain/usecases/authorization/get_access_token_usecase.dart';

class RoleGuard extends AutoRouteGuard {
  final GetAccessTokenUseCase _getAccessTokenUseCase;
  final List<String> allowedRoles;

  RoleGuard(this._getAccessTokenUseCase, this.allowedRoles);

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final token = _getAccessTokenUseCase();

    if (token == null || token.isEmpty || JwtDecoder.isExpired(token)) {
      await router.push(const LoginRoute());
      return;
    }

    final decoded = JwtDecoder.decode(token);
    final rolesRaw = decoded['roles'];
    final List<String> userRoles = rolesRaw is List
        ? rolesRaw.map((e) => e.toString()).toList()
        : [];

    final hasAccess = userRoles.any(allowedRoles.contains);

    if (hasAccess) {
      resolver.next();
    } else {
      await router.replace(const HomeRoute());
    }
  }
}
