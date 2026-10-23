import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/api_failure.dart';

/// Base class for every use case. Use cases never throw; they return
/// `Left(ApiFailure)` or `Right(T)`.
abstract class UseCase<T, Params> {
  Future<Either<ApiFailure, T>> call(Params params);
}

/// Pass to use cases that take no input.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
