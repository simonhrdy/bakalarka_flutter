import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart' as default_provider;
import 'package:sportmatter/config/themes/app_theme.dart';
import 'package:sportmatter/config/themes/routes/app_router.dart';
import 'package:sportmatter/l10n/arb/app_localizations.g.dart';

class App extends StatefulWidget {
  final AppRouter appRouter;

  const App(this.appRouter, {super.key});

  @override
  State<StatefulWidget> createState() => _AppState();

  static _AppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>();
}

class _AppState extends State<App> {
  Locale _locale = const Locale('cs');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  Locale get locale => _locale;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final themeData = AppTheme(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: default_provider.Provider.value(
        value: themeData,
        child: MaterialApp.router(
          locale: _locale,
          key: widget.key,
          theme: themeData.basic,
          routeInformationParser: widget.appRouter.defaultRouteParser(),
          routerDelegate: widget.appRouter.delegate(),
          supportedLocales: const [
            Locale('en'),
            Locale('cs'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          onGenerateTitle: (context) => "SportMatter",
          showSemanticsDebugger: false,
          debugShowCheckedModeBanner: false,
          builder: (BuildContext context, Widget? child) {
            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return false;
              },
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: true,
                  textScaler: TextScaler.noScaling,
                ),
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
        ),
      ),
    );
  }
}
