import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:safe_device/safe_device.dart';

@lazySingleton
class DeviceInformationHelper {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Stable device identifier (survives reinstall on most devices).
  Future<String> getDeviceId() => FlutterUdid.consistentUdid;

  Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return '${info.version}+${info.buildNumber}';
  }

  Future<String> getDeviceModel() async {
    if (Platform.isAndroid) {
      final android = await _deviceInfo.androidInfo;
      return '${android.manufacturer} ${android.model}';
    }
    if (Platform.isIOS) {
      final ios = await _deviceInfo.iosInfo;
      return ios.utsname.machine;
    }
    return Platform.operatingSystem;
  }

  String get platform => Platform.operatingSystem;

  /// True if the device is rooted/jailbroken or an emulator.
  Future<bool> isCompromised() async {
    final jailBroken = await SafeDevice.isJailBroken;
    final realDevice = await SafeDevice.isRealDevice;
    return jailBroken || !realDevice;
  }
}
