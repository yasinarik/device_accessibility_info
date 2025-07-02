import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_accessibility_info/device_accessibility_info_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDeviceAccessibilityInfo platform =
      MethodChannelDeviceAccessibilityInfo();
  const MethodChannel methodChannel =
      MethodChannel('device_accessibility_info/methods');
  const EventChannel eventChannel =
      EventChannel('device_accessibility_info/events');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      methodChannel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getPlatformVersion':
            return '42';
          case 'isScreenReaderEnabled':
            return true;
          default:
            throw PlatformException(
                code: 'UNIMPLEMENTED', message: 'Method not implemented');
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('isScreenReaderEnabled', () async {
    expect(await platform.isScreenReaderEnabled(), true);
  });

  test('screenReaderStatusChanged stream', () async {
    // Mock the event channel stream
    const stream = [true, false, true];

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
      eventChannel,
      MockStreamHandler.inline(
        onListen: (Object? arguments, MockStreamHandlerEventSink events) {
          for (final event in stream) {
            events.success(event);
          }
          events.endOfStream();
        },
      ),
    );

    final statusStream = platform.screenReaderStatusChanged;
    final events = await statusStream.take(3).toList();
    expect(events, [true, false, true]);
  });
}
