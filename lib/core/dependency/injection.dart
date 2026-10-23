import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../network/interceptors/encryption_interceptor.dart';
import '../network/interceptors/internet_connection_checker_interceptor.dart';
import '../network/interceptors/sim_check_interceptor.dart';
import '../network/services/api_service.dart';
import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

/// Third-party types that can't be annotated directly.
@module
abstract class RegisterModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  InternetConnection get internetConnection => InternetConnection();

  @lazySingleton
  Dio dio(
    InternetConnectionCheckerInterceptor connectionInterceptor,
    SimCheckInterceptor simCheckInterceptor,
    EncryptionInterceptor encryptionInterceptor,
  ) => ApiClient.create(
    connectionInterceptor: connectionInterceptor,
    simCheckInterceptor: simCheckInterceptor,
    encryptionInterceptor: encryptionInterceptor,
  );

  @lazySingleton
  ApiService apiService(Dio dio) =>
      ApiService(dio, baseUrl: ApiEndpoints.baseUrl);
}
