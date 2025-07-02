import 'device_accessibility_info_platform_interface.dart';

class DeviceAccessibilityInfo {
  Future<String?> getPlatformVersion() {
    return DeviceAccessibilityInfoPlatform.instance.getPlatformVersion();
  }

  /// Returns whether the screen reader is currently enabled.
  ///
  /// On iOS, this checks if VoiceOver is running.
  /// On Android, this checks if TalkBack is enabled.
  ///
  /// Returns `true` if screen reader is enabled, `false` otherwise.
  Future<bool> isScreenReaderEnabled() {
    return DeviceAccessibilityInfoPlatform.instance.isScreenReaderEnabled();
  }

  /// Returns a stream that emits screen reader status changes.
  ///
  /// The stream emits `true` when screen reader is enabled and `false` when disabled.
  /// On iOS, this listens for VoiceOver status changes.
  /// On Android, this listens for TalkBack status changes.
  ///
  /// Example usage:
  /// ```dart
  /// DeviceAccessibilityInfo().screenReaderStatusChanged.listen((isEnabled) {
  ///   print('Screen reader is ${isEnabled ? 'enabled' : 'disabled'}');
  /// });
  /// ```
  Stream<bool> get screenReaderStatusChanged {
    return DeviceAccessibilityInfoPlatform.instance.screenReaderStatusChanged;
  }
}
