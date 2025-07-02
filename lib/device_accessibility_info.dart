
import 'device_accessibility_info_platform_interface.dart';

class DeviceAccessibilityInfo {
  Future<String?> getPlatformVersion() {
    return DeviceAccessibilityInfoPlatform.instance.getPlatformVersion();
  }
}
