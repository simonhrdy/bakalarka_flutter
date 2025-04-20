import 'package:dio/dio.dart';

class RequestState<T> {
  final T? data;
  final bool isLocal;
  final bool hasError;
  final bool isLoading;
  final bool isRefetching;
  final DioException? error;
  final String? loadingText;
  final Future Function({bool keepState})? refetch;

  const RequestState(
      {this.hasError = false,
      this.isLoading = false,
      this.isRefetching = false,
      this.isLocal = false,
      this.error,
      this.refetch,
      this.loadingText,
      this.data});

  bool get hasData => data != null;

  T get value => data!;

  bool get pristine => isLoading == false && hasError == false && data == null;

  factory RequestState.loading({String? loadingText}) =>
      RequestState(isLoading: true, loadingText: loadingText);

  factory RequestState.error(
          {DioException? error, Future Function({bool keepState})? refetch}) =>
      RequestState(hasError: true, error: error, refetch: refetch);
}
