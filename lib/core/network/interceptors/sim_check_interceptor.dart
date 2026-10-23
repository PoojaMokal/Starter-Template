import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Blocks requests when the SIM binding check fails. Active only in
/// release/profile builds (`!kDebugMode`).
@lazySingleton
class SimCheckInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (kDebugMode || await _isSimValid()) {
      return handler.next(options);
    }
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.cancel,
        message: 'SIM verification failed',
      ),
    );
  }

  // TODO: implement SIM binding (e.g. compare the registered SIM/carrier
  // with the current one via a platform channel). Stub always passes.
  Future<bool> _isSimValid() async => true;
}
