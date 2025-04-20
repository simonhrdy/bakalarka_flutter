abstract class ParametrizedUseCase<T, P> {
  Future<T> call({required P params});
}

abstract class SimpleUseCase<T> {
  Future<T> call();
}

abstract class ParametrizedSyncUseCase<T, P> {
  T call({required P params});
}

abstract class SimpleSyncUseCase<T> {
  T call();
}
