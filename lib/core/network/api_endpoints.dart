class ApiEndpoints {
  ApiEndpoints._();

  /// Active environment: 'local' | 'UAT'. Change this to switch backends.
  static const String env = 'local';

  static bool get isLocal => env == 'local';

  // TODO: replace with the real base URLs. Retrofit paths below are
  // relative, so keep the trailing slash.
  static String get baseUrl => switch (env) {
    'UAT' => 'https://uat.example.com/api/',
    _ => 'http://10.0.2.2:8080/api/', // Android emulator → host localhost
  };

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Auth
  static const String login = 'auth/login';
}
