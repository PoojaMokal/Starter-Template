import 'package:injectable/injectable.dart';

/// Holds the logged-in session in memory. Persisted copies live in
/// StorageManager.
@lazySingleton
class SessionManager {
  String? _token;
  String? _cif;

  String? get token => _token;
  String? get cif => _cif;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  void startSession({required String token, String? cif}) {
    _token = token;
    _cif = cif;
  }

  void clear() {
    _token = null;
    _cif = null;
  }
}
