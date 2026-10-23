import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';

import '../helper/app_logger.dart';

/// Remote Config keys. Add defaults in [FirebaseRemoteConfigService._defaults].
class RemoteConfigKeys {
  RemoteConfigKeys._();

  static const String minSupportedVersion = 'min_supported_version';
  static const String maintenanceMode = 'maintenance_mode';
}

@lazySingleton
class FirebaseRemoteConfigService {
  FirebaseRemoteConfig get _config => FirebaseRemoteConfig.instance;

  static const Map<String, dynamic> _defaults = {
    RemoteConfigKeys.minSupportedVersion: '1.0.0',
    RemoteConfigKeys.maintenanceMode: false,
  };

  Future<void> initialize() async {
    try {
      await _config.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await _config.setDefaults(_defaults);
      await _config.fetchAndActivate();
    } catch (e, s) {
      appLogger.w('Remote config fetch failed', error: e, stackTrace: s);
    }
  }

  String getString(String key) => _config.getString(key);
  bool getBool(String key) => _config.getBool(key);
  int getInt(String key) => _config.getInt(key);
}
