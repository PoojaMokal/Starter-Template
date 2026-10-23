import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:injectable/injectable.dart';

/// Encrypts every request body and decrypts every response payload so
/// features only ever see plain JSON. Features must never encrypt manually.
@lazySingleton
class EncryptionInterceptor extends Interceptor {
  EncryptionInterceptor(this._cipher);

  final PayloadCipher _cipher;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final data = options.data;
    if (_cipher.isEnabled && data != null && data is! FormData) {
      // TODO: match the backend's request envelope.
      options.data = {'rb': _cipher.encrypt(jsonEncode(data))};
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;
    if (_cipher.isEnabled && data is Map<String, dynamic>) {
      final payload = data['p'];
      final body = payload is Map<String, dynamic> ? payload['rb'] : null;
      if (body is String && body.isNotEmpty) {
        try {
          payload!['rb'] = jsonDecode(_cipher.decrypt(body));
        } catch (e) {
          return handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.unknown,
              error: e,
              message: 'Failed to decrypt response',
            ),
          );
        }
      }
    }
    handler.next(response);
  }
}

// =============================================================================
// TODO(encryption): PLACEHOLDER — replace with the real algorithm and keys.
//
// This is a plain AES-256-CBC stub with hard-coded dummy key/IV so the
// pipeline compiles. Before enabling:
//   1. Set the real algorithm / mode / padding agreed with the backend.
//   2. Load key + IV securely (never commit real keys).
//   3. Flip [isEnabled] to true.
// =============================================================================
@lazySingleton
class PayloadCipher {
  /// While false, requests/responses pass through unencrypted.
  bool get isEnabled => false;

  static final _key = enc.Key.fromUtf8('00000000000000000000000000000000');
  static final _iv = enc.IV.fromUtf8('0000000000000000');

  final enc.Encrypter _encrypter = enc.Encrypter(
    enc.AES(_key, mode: enc.AESMode.cbc),
  );

  String encrypt(String plainText) =>
      _encrypter.encrypt(plainText, iv: _iv).base64;

  String decrypt(String cipherText) =>
      _encrypter.decrypt64(cipherText, iv: _iv);
}
