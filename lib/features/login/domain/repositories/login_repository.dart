import 'package:dartz/dartz.dart';

import '../../../../core/errors/api_failure.dart';
import '../../data/models/login_request.dart';
import '../../data/models/login_response.dart';

abstract class LoginRepository {
  /// Authenticates and persists the session on success.
  Future<Either<ApiFailure, LoginResponse>> login(LoginRequest request);
}
