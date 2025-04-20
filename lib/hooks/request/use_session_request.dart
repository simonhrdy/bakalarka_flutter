import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/data/resources/request_state.dart';

class RequestStateCache<T> {
  final String key;

  late final StreamController<RequestState<T>> _controller;

  RequestStateCache(this.key) {
    _controller = StreamController.broadcast();
    _latestValue = RequestState<T>();
    _controller.sink.add(_latestValue);
  }

  RequestState<T> _latestValue = const RequestState();
  RequestState<T> get latestValue => _latestValue;

  void clean() {
    _latestValue = const RequestState();
    _controller.sink.add(const RequestState());
  }

  StreamSubscription<RequestState<T>> listen(
      void Function(RequestState<T> state) listener) {
    return _controller.stream.listen((event) {
      listener(event);
    });
  }

  void push(RequestState<T> state) {
    _latestValue = state;
    _controller.sink.add(state);
  }
}

final Map<String, RequestStateCache> _streamBag = <String, RequestStateCache>{};

RequestStateCache<T> _getStreamForKey<T>(String key) {
  if (!_streamBag.containsKey(key)) {
    _streamBag[key] = RequestStateCache<T>(key);
  }
  return _streamBag[key] as RequestStateCache<T>;
}

RequestState<T> _getStreamData<T>(String key,
    {Function(T?)? onSuccess, bool isInitialyDisabled = false}) {
  final requestState = _streamBag[key]?.latestValue as RequestState<T>?;
  if (requestState != null) {
    if (requestState.hasData) {
      onSuccess?.call(requestState.data);
    }
    return requestState;
  }
  return isInitialyDisabled ? const RequestState() : RequestState.loading();
}

VoidCallback useClearSessionRequest(String key) =>
    () => _streamBag[key]?.clean();

RequestStateCache<T> useSessionStream<T>(String key) {
  return _getStreamForKey<T>(key);
}

RequestState<T> useSessionRequest<T>(
    {required Future<DataState<T?>?> Function(RequestStateCache<T>) fetcher,
    required String key,
    bool enabled = true,
    Function(T?)? onSuccess}) {
  final context = useContext();

  final previousKeyRef = useRef(key);
  final state = useState(_getStreamData<T>(key,
      onSuccess: onSuccess, isInitialyDisabled: !enabled));

  useEffect(() {
    final requestStream = _getStreamForKey<T>(key);

    final sub = requestStream.listen((streamState) {
      if (context.mounted) {
        state.value = streamState;
      }
    });

    Future fetchFn({bool isRefetch = false}) async {
      final streamState = requestStream.latestValue;

      if ((streamState.isLoading || streamState.hasData) &&
          !isRefetch &&
          !streamState.isLocal &&
          previousKeyRef.value == key) {
        return;
      }
      if (previousKeyRef.value != key) {
        previousKeyRef.value = key;
      }
      try {
        if (!streamState.isLocal && !isRefetch) {
          requestStream.push(RequestState.loading());
        }

        final DataState<T?>? response = await fetcher(requestStream);

        if (response == null) {
          if (!streamState.isLocal) {
            requestStream.push(RequestState.error(
                refetch: ({bool keepState = false}) =>
                    fetchFn(isRefetch: true)));
          }
          return;
        }

        if (response is DataSuccess) {
          final T? data = response.data;
          onSuccess?.call(data);
          requestStream.push(RequestState(
              data: data,
              refetch: ({bool keepState = false}) {
                if (!keepState) {
                  requestStream.push(const RequestState());
                }
                return fetchFn(isRefetch: true);
              }));
        } else {
          requestStream.push(
            RequestState.error(
              error: response.error,
              refetch: ({bool keepState = false}) => fetchFn(isRefetch: true),
            ),
          );
        }
      } catch (e, stacktrace) {
        requestStream.push(
          RequestState.error(
            refetch: ({bool keepState = false}) => fetchFn(isRefetch: true),
          ),
        );
      }
    }

    if (enabled) {
      fetchFn();
    }
    return () => sub.cancel();
  }, [enabled, key]);

  return state.value;
}
