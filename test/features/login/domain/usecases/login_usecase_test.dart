import 'package:base_project/core/errors/api_failure.dart';
import 'package:base_project/features/login/data/models/login_request.dart';
import 'package:base_project/features/login/data/models/login_response.dart';
import 'package:base_project/features/login/domain/repositories/login_repository.dart';
import 'package:base_project/features/login/domain/usecases/login_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late MockLoginRepository repository;
  late LoginUseCase useCase;

  const request = LoginRequest(userId: 'user01', password: 'secret');
  const response = LoginResponse(token: 'token-123', cif: 'CIF001');

  setUpAll(() => registerFallbackValue(request));

  setUp(() {
    repository = MockLoginRepository();
    useCase = LoginUseCase(repository);
  });

  test('returns LoginResponse when the repository succeeds', () async {
    when(
      () => repository.login(any()),
    ).thenAnswer((_) async => const Right(response));

    final result = await useCase(request);

    expect(result, const Right<ApiFailure, LoginResponse>(response));
    verify(() => repository.login(request)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('returns ApiFailure when the repository fails', () async {
    const failure = ApiFailure.unauthorized();
    when(
      () => repository.login(any()),
    ).thenAnswer((_) async => const Left(failure));

    final result = await useCase(request);

    expect(result, const Left<ApiFailure, LoginResponse>(failure));
    verify(() => repository.login(request)).called(1);
  });
}
