import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app.dart';
import 'core/dependency/firebase_remote_config.dart';
import 'core/dependency/injection.dart';
import 'core/helper/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firebaseReady = await _initFirebase();
  await configureDependencies();
  if (firebaseReady) {
    unawaited(getIt<FirebaseRemoteConfigService>().initialize());
  }

  runApp(const ProviderScope(child: App()));
}

Future<bool> _initFirebase() async {
  try {
    // TODO: run `flutterfire configure` and pass
    // `options: DefaultFirebaseOptions.currentPlatform`, or add
    // google-services.json / GoogleService-Info.plist.
    await Firebase.initializeApp();

    final crashlytics = FirebaseCrashlytics.instance;
    await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
    FlutterError.onError = crashlytics.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
    return true;
  } catch (e, s) {
    // App still runs without Firebase until it is configured.
    appLogger.w('Firebase not initialised', error: e, stackTrace: s);
    return false;
  }
}
