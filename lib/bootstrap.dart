import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:sportmatter/app.dart';
import 'package:sportmatter/config/injector/api/interceptor_injector.dart';
import 'package:sportmatter/config/injector/injector.dart';
import 'package:sportmatter/config/interceptors/interceptors.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap() async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here

  WidgetsFlutterBinding.ensureInitialized();

  try {
    await initializeInjector();
  } catch(e){
    print('Initial $e');
  }

  try {
    await setupInterceptorInjector(injector);
  } catch(e){
    print('StupIntectoj $e');
  }

  try {
    await initializeInterceptors(injector(), injector());
  } catch(e){
    print('Interceotioris $e');
  }


  runApp(App(injector()));
}
