import 'package:get_it/get_it.dart';
import 'package:sportmatter/config/interceptors/token_interceptor.dart';

Future<void> setupInterceptorInjector(GetIt injector) async {
  injector.registerSingleton<TokenInterceptor>(TokenInterceptor(injector()));
}
