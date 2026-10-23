import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/api_failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/login_request.dart';
import '../../data/models/login_response.dart';
import '../repositories/login_repository.dart';

@injectable
class LoginUseCase implements UseCase<LoginResponse, LoginRequest> {
  LoginUseCase(this._repository);

  final LoginRepository _repository;

  @override
  Future<Either<ApiFailure, LoginResponse>> call(LoginRequest params) =>
      _repository.login(params);
}
