import 'package:flutter_test/flutter_test.dart';
import 'package:device_accessibility_info/device_accessibility_info.dart';
import 'package:device_accessibility_info/device_accessibility_info_platform_interface.dart';
import 'package:device_accessibility_info/device_accessibility_info_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDeviceAccessibilityInfoPlatform
    with MockPlatformInterfaceMixin
    implements DeviceAccessibilityInfoPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> isScreenReaderEnabled() => Future.value(true);

  @override
  Stream<bool> get screenReaderStatusChanged =>
      Stream.fromIterable([true, false, true]);
}

void main() {
  final DeviceAccessibilityInfoPlatform initialPlatform =
      DeviceAccessibilityInfoPlatform.instance;

  test('$MethodChannelDeviceAccessibilityInfo is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelDeviceAccessibilityInfo>());
  });

  test('getPlatformVersion', () async {
    DeviceAccessibilityInfo deviceAccessibilityInfoPlugin =
        DeviceAccessibilityInfo();
    MockDeviceAccessibilityInfoPlatform fakePlatform =
        MockDeviceAccessibilityInfoPlatform();
    DeviceAccessibilityInfoPlatform.instance = fakePlatform;

    expect(await deviceAccessibilityInfoPlugin.getPlatformVersion(), '42');
  });

  test('isScreenReaderEnabled', () async {
    DeviceAccessibilityInfo deviceAccessibilityInfoPlugin =
        DeviceAccessibilityInfo();
    MockDeviceAccessibilityInfoPlatform fakePlatform =
        MockDeviceAccessibilityInfoPlatform();
    DeviceAccessibilityInfoPlatform.instance = fakePlatform;

    expect(await deviceAccessibilityInfoPlugin.isScreenReaderEnabled(), true);
  });

  test('screenReaderStatusChanged stream', () async {
    DeviceAccessibilityInfo deviceAccessibilityInfoPlugin =
        DeviceAccessibilityInfo();
    MockDeviceAccessibilityInfoPlatform fakePlatform =
        MockDeviceAccessibilityInfoPlatform();
    DeviceAccessibilityInfoPlatform.instance = fakePlatform;

    final stream = deviceAccessibilityInfoPlugin.screenReaderStatusChanged;
    final events = await stream.take(3).toList();
    expect(events, [true, false, true]);
  });
}
