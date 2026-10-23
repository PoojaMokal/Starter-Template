import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../features/login/data/models/login_request.dart';
import '../../../features/login/data/models/login_response.dart';
import '../../../models/base_response/base_response.dart';
import '../api_endpoints.dart';

part 'api_service.g.dart';

/// The ONLY Retrofit service. Add every endpoint here, grouped by feature.
@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  // ---- Auth ----
  @POST(ApiEndpoints.login)
  Future<BaseResponse<LoginResponse>> login(@Body() LoginRequest request);
}
