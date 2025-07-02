import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'device_accessibility_info_platform_interface.dart';

/// An implementation of [DeviceAccessibilityInfoPlatform] that uses method channels.
class MethodChannelDeviceAccessibilityInfo extends DeviceAccessibilityInfoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('device_accessibility_info');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
