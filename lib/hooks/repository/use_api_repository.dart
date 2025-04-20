import 'package:sportmatter/domain/repositories/api_repository.dart';
import 'package:sportmatter/hooks/inject/use_injector.dart';

ApiRepository useApiRepository() {
  return useInjector<ApiRepository>();
}
