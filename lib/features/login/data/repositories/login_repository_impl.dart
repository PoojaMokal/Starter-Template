import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/strings/app_strings.dart';
import '../../../../core/errors/api_failure.dart';
import '../../../../core/helper/app_logger.dart';
import '../../../../core/helper/session_manager.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/storage/storage_manager.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_remote_datasource.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

@LazySingleton(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl(
    this._remoteDataSource,
    this._storageManager,
    this._sessionManager,
  );

  final LoginRemoteDataSource _remoteDataSource;
  final StorageManager _storageManager;
  final SessionManager _sessionManager;

  @override
  Future<Either<ApiFailure, LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _remoteDataSource.login(request);
      final body = response.body;
      if (!response.isSuccess || body == null) {
        return Left(
          ApiFailure.server(
            message:
                response.payload?.message ?? AppStrings.somethingWentWrong,
          ),
        );
      }

      await _storageManager.write(StorageKey.token, body.token);
      if (body.cif != null) {
        await _storageManager.write(StorageKey.cif, body.cif!);
      }
      _sessionManager.startSession(token: body.token, cif: body.cif);

      return Right(body);
    } on DioException catch (e) {
      return Left(ApiFailure.fromDioException(e));
    } catch (e, s) {
      appLogger.e('Login failed', error: e, stackTrace: s);
      return const Left(ApiFailure.unknown());
    }
  }
}
