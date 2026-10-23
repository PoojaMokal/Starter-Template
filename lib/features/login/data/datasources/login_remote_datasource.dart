import 'package:injectable/injectable.dart';

import '../../../../core/network/services/api_service.dart';
import '../../../../models/base_response/base_response.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

abstract class LoginRemoteDataSource {
  /// Throws [DioException] on failure; the repository maps it.
  Future<BaseResponse<LoginResponse>> login(LoginRequest request);
}

@LazySingleton(as: LoginRemoteDataSource)
class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  LoginRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<BaseResponse<LoginResponse>> login(LoginRequest request) =>
      _apiService.login(request);
}
