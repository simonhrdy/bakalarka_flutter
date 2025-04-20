import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sportmatter/config/interceptors/token_interceptor.dart';

Future<void> initializeInterceptors(
  Dio dio,
  TokenInterceptor tokenInterceptor,
) async {
  dio.interceptors.add(tokenInterceptor);

  dio.interceptors.add(PrettyDioLogger(
    requestBody: false,
    requestHeader: false,
    responseBody: false,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 90,
  ));

  return Future.value();
}
