import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../constants/strings/app_strings.dart';
import '../network_info.dart';

/// Fails fast with [DioExceptionType.connectionError] when offline, which
/// repositories map to `ApiFailure.network`.
@lazySingleton
class InternetConnectionCheckerInterceptor extends Interceptor {
  InternetConnectionCheckerInterceptor(this._networkInfo);

  final NetworkInfo _networkInfo;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (await _networkInfo.isConnected) {
      return handler.next(options);
    }
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
        message: AppStrings.noInternet,
      ),
    );
  }
}
