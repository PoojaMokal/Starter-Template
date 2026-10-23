import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../constants/strings/app_strings.dart';

part 'api_failure.freezed.dart';

@freezed
sealed class ApiFailure with _$ApiFailure {
  const factory ApiFailure.server({required String message, int? statusCode}) =
      ServerFailure;

  const factory ApiFailure.network({
    @Default(AppStrings.noInternet) String message,
  }) = NetworkFailure;

  const factory ApiFailure.unauthorized({
    @Default(AppStrings.sessionExpired) String message,
  }) = UnauthorizedFailure;

  const factory ApiFailure.unknown({
    @Default(AppStrings.somethingWentWrong) String message,
  }) = UnknownFailure;

  /// Maps a [DioException] to an [ApiFailure]. Used by every repository.
  factory ApiFailure.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
        return const ApiFailure.network();
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiFailure.network(message: AppStrings.requestTimeout);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return const ApiFailure.unauthorized();
        }
        return ApiFailure.server(
          message: _serverMessage(e.response?.data) ??
              AppStrings.somethingWentWrong,
          statusCode: statusCode,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return ApiFailure.unknown(
          message: e.message ?? AppStrings.somethingWentWrong,
        );
    }
  }

  // TODO: adjust to wherever the backend puts its error message.
  static String? _serverMessage(dynamic data) {
    if (data is Map) {
      final message = data['message'] ?? data['msg'];
      if (message is String && message.isNotEmpty) return message;
    }
    return null;
  }
}
