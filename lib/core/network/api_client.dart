import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import 'api_endpoints.dart';
import 'interceptors/encryption_interceptor.dart';
import 'interceptors/internet_connection_checker_interceptor.dart';
import 'interceptors/sim_check_interceptor.dart';

/// Builds the single [Dio] instance used by ApiService. Registered in DI via
/// RegisterModule — don't construct Dio anywhere else.
class ApiClient {
  ApiClient._();

  static Dio create({
    required InternetConnectionCheckerInterceptor connectionInterceptor,
    required SimCheckInterceptor simCheckInterceptor,
    required EncryptionInterceptor encryptionInterceptor,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        sendTimeout: ApiEndpoints.sendTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    // Order matters: request and response interceptors both run in
    // insertion order, so the logger sees the encrypted request and the
    // decrypted response.
    dio.interceptors.addAll([
      connectionInterceptor,
      simCheckInterceptor,
      encryptionInterceptor,
      if (kDebugMode) TalkerDioLogger(),
    ]);

    // Accept self-signed certificates against the local backend only.
    if (kDebugMode && ApiEndpoints.isLocal) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () =>
            HttpClient()..badCertificateCallback = (_, _, _) => true,
      );
    }

    return dio;
  }
}
