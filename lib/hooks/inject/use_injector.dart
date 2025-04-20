import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/injector/injector.dart';

T useInjector<T extends Object>() {
  return useMemoized(() => injector<T>());
}
