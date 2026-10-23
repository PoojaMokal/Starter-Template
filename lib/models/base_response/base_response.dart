import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_response.freezed.dart';
part 'base_response.g.dart';

/// Envelope returned by every API (decode-only, so no toJson).
/// Wire keys are abbreviated:
/// `s` status, `p` payload, `h` header, `c` code.
@Freezed(genericArgumentFactories: true, toJson: false)
abstract class BaseResponse<T> with _$BaseResponse<T> {
  const BaseResponse._();

  @JsonSerializable(genericArgumentFactories: true, createToJson: false)
  const factory BaseResponse({
    @JsonKey(name: 's') String? status,
    @JsonKey(name: 'p') ResponsePayload<T>? payload,
    @JsonKey(name: 'h') Map<String, dynamic>? header,
    @JsonKey(name: 'c') String? code,
  }) = _BaseResponse<T>;

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$BaseResponseFromJson(json, fromJsonT);

  /// Decrypted response body (`p.rb`).
  T? get body => payload?.body;

  // TODO: confirm the success values used by the backend.
  bool get isSuccess {
    final value = status?.toLowerCase();
    return value == 'success' || value == 's' || value == '00' || code == '00';
  }
}

/// `p` section of [BaseResponse]. `rb` holds the body after
/// EncryptionInterceptor has decrypted it.
@Freezed(genericArgumentFactories: true, toJson: false)
abstract class ResponsePayload<T> with _$ResponsePayload<T> {
  @JsonSerializable(genericArgumentFactories: true, createToJson: false)
  const factory ResponsePayload({
    @JsonKey(name: 'rb') T? body,
    @JsonKey(name: 'msg') String? message,
  }) = _ResponsePayload<T>;

  factory ResponsePayload.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ResponsePayloadFromJson(json, fromJsonT);
}
