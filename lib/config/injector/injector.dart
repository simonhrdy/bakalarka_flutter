import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportmatter/config/injector/api/api_service_injector.dart';
import 'package:sportmatter/config/injector/api/dio_injector.dart';
import 'package:sportmatter/config/themes/routes/app_router.dart';
import 'package:sportmatter/config/themes/routes/auth_guard.dart';
import 'package:sportmatter/config/themes/routes/guest_guard.dart';
import 'package:sportmatter/config/themes/routes/role_guard.dart';
import 'package:sportmatter/data/repositories/api_repository_impl.dart';
import 'package:sportmatter/data/repositories/setting_repository_impl.dart';
import 'package:sportmatter/domain/repositories/api_repository.dart';
import 'package:sportmatter/domain/repositories/setting_repository.dart';
import 'package:sportmatter/domain/usecases/authorization/get_access_token_usecase.dart';
import 'package:sportmatter/domain/usecases/save_current_user_usecase.dart';
import 'package:sportmatter/domain/usecases/save_token_usecase.dart';
import 'package:sportmatter/domain/usecases/setting/get_string_setting_usecase.dart';
import 'package:sportmatter/domain/usecases/setting/save_string_setting_usecase.dart';

final GetIt injector = GetIt.instance;

Future<void> initializeInjector() async {
  setupDioInjector(injector);
  setupApiServiceInjector(injector);

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  injector
    ..registerSingleton<SettingsRepository>(SettingsRepositoryImpl(prefs))
    ..registerSingleton<ApiRepository>(ApiRepositoryImpl(injector()))
    ..registerSingleton<SaveSettingUseCase>(SaveSettingUseCase(injector()))
    ..registerSingleton<SaveCurrentUserUseCase>(
        SaveCurrentUserUseCase(injector()))
    ..registerSingleton<GetStringSettingUseCase>(
        GetStringSettingUseCase(injector()))
    ..registerSingleton<SaveTokenUsecase>(SaveTokenUsecase(injector()))
    ..registerSingleton<GetAccessTokenUseCase>(
        GetAccessTokenUseCase(injector()))

    ..registerSingleton<AuthGuard>(AuthGuard(injector()))
    ..registerSingleton<RoleGuard>(
        RoleGuard(injector(), ['ROLE_SUPERADMIN']))
    ..registerSingleton<RoleGuard>(
      RoleGuard(injector(), ['ROLE_SUPERADMIN', 'ROLE_MANAGER']),
      instanceName: 'managerGuard',
    )
    ..registerSingleton<GuestGuard>(
      GuestGuard(injector()),
    )

    ..registerSingleton<AppRouter>(
      AppRouter(
        authGuard: injector<AuthGuard>(),
        superAdminGuard: injector<RoleGuard>(),
        managerGuard: injector<RoleGuard>(instanceName: 'managerGuard'),
        guestGuard: injector<GuestGuard>(),
      ),
    );
}

