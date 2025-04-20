import 'package:get_it/get_it.dart';
import 'package:sportmatter/config/constants/constants.dart';
import 'package:sportmatter/data/datasources/api_service.dart';

void setupApiServiceInjector(GetIt injector) {
  String baseUrl = kBaseUrl;

  // injector.registerSingleton<AuthorizationApiService>(
  //     AuthorizationApiService(injector(), baseUrl: baseUrl));

  injector
      .registerSingleton<ApiService>(ApiService(injector(), baseUrl: baseUrl));
}
