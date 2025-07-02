import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'device_accessibility_info_platform_interface.dart';

/// An implementation of [DeviceAccessibilityInfoPlatform] that uses method channels.
class MethodChannelDeviceAccessibilityInfo
    extends DeviceAccessibilityInfoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('device_accessibility_info/methods');

  /// The event channel used to listen for screen reader status changes.
  @visibleForTesting
  final eventChannel = const EventChannel('device_accessibility_info/events');

  Stream<bool>? _screenReaderStatusStream;

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> isScreenReaderEnabled() async {
    final isEnabled =
        await methodChannel.invokeMethod<bool>('isScreenReaderEnabled');
    return isEnabled ?? false;
  }

  @override
  Stream<bool> get screenReaderStatusChanged {
    _screenReaderStatusStream ??= eventChannel
        .receiveBroadcastStream()
        .map<bool>((dynamic event) => event as bool);
    return _screenReaderStatusStream!;
  }
}
