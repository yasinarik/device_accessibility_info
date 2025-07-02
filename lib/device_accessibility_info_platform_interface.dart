import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'device_accessibility_info_method_channel.dart';

abstract class DeviceAccessibilityInfoPlatform extends PlatformInterface {
  /// Constructs a DeviceAccessibilityInfoPlatform.
  DeviceAccessibilityInfoPlatform() : super(token: _token);

  static final Object _token = Object();

  static DeviceAccessibilityInfoPlatform _instance =
      MethodChannelDeviceAccessibilityInfo();

  /// The default instance of [DeviceAccessibilityInfoPlatform] to use.
  ///
  /// Defaults to [MethodChannelDeviceAccessibilityInfo].
  static DeviceAccessibilityInfoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DeviceAccessibilityInfoPlatform] when
  /// they register themselves.
  static set instance(DeviceAccessibilityInfoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Returns whether the screen reader (VoiceOver on iOS, TalkBack on Android) is currently enabled.
  Future<bool> isScreenReaderEnabled() {
    throw UnimplementedError(
        'isScreenReaderEnabled() has not been implemented.');
  }

  /// Returns a stream that notifies when the screen reader status changes.
  /// The stream emits `true` when screen reader is enabled, `false` when disabled.
  Stream<bool> get screenReaderStatusChanged {
    throw UnimplementedError(
        'screenReaderStatusChanged has not been implemented.');
  }
}
