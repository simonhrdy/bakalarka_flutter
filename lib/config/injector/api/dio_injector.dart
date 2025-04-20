import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

void setupDioInjector(GetIt injector) {
  injector.registerSingleton<Dio>(Dio());
}
