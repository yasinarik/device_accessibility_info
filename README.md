# Device Accessibility Info

[![pub package](https://img.shields.io/pub/v/device_accessibility_info.svg)](https://pub.dev/packages/device_accessibility_info)
[![Platform](https://img.shields.io/badge/platform-flutter-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A Flutter plugin that provides information about device accessibility features, particularly screen reader status detection and real-time change notifications.

**Created by [Yasin Arik](https://linkedin.com/in/yasinarik)** 👨‍💻

## Features

- ✅ **Screen Reader Detection**: Check if VoiceOver (iOS) or TalkBack (Android) is currently enabled
- ✅ **Real-time Notifications**: Listen for screen reader status changes as they happen
- ✅ **Cross-platform**: Works on both iOS and Android
- ✅ **Easy Integration**: Simple API with Future-based and Stream-based methods
- ✅ **Well Tested**: Comprehensive unit tests included

## Platform Support

| Platform | Screen Reader | Detection Method |
|----------|---------------|------------------|
| iOS      | VoiceOver     | `UIAccessibility.isVoiceOverRunning` |
| Android  | TalkBack      | `AccessibilityManager` + Settings monitoring |

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  device_accessibility_info: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Import the package

```dart
import 'package:device_accessibility_info/device_accessibility_info.dart';
```

### Check current screen reader status

```dart
final plugin = DeviceAccessibilityInfo();

// Check if screen reader is currently enabled
bool isEnabled = await plugin.isScreenReaderEnabled();
print('Screen reader is ${isEnabled ? 'enabled' : 'disabled'}');
```

### Listen for screen reader status changes

```dart
final plugin = DeviceAccessibilityInfo();

// Listen for real-time changes
StreamSubscription<bool> subscription = plugin.screenReaderStatusChanged.listen(
  (bool isEnabled) {
    print('Screen reader status changed: ${isEnabled ? 'enabled' : 'disabled'}');
    // Update your UI accordingly
  },
);

// Don't forget to cancel the subscription
subscription.cancel();
```

### Complete example

```dart
import 'package:flutter/material.dart';
import 'package:device_accessibility_info/device_accessibility_info.dart';
import 'dart:async';

class AccessibilityScreen extends StatefulWidget {
  @override
  _AccessibilityScreenState createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  final _plugin = DeviceAccessibilityInfo();
  bool _isScreenReaderEnabled = false;
  StreamSubscription<bool>? _subscription;

  @override
  void initState() {
    super.initState();
    _checkInitialStatus();
    _listenForChanges();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _checkInitialStatus() async {
    try {
      bool isEnabled = await _plugin.isScreenReaderEnabled();
      setState(() {
        _isScreenReaderEnabled = isEnabled;
      });
    } catch (e) {
      print('Error checking screen reader status: $e');
    }
  }

  void _listenForChanges() {
    _subscription = _plugin.screenReaderStatusChanged.listen(
      (bool isEnabled) {
        setState(() {
          _isScreenReaderEnabled = isEnabled;
        });
      },
      onError: (error) {
        print('Error listening to screen reader changes: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accessibility Info'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isScreenReaderEnabled 
                ? Icons.accessibility 
                : Icons.accessibility_outlined,
              size: 64,
              color: _isScreenReaderEnabled ? Colors.green : Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Screen reader is ${_isScreenReaderEnabled ? 'enabled' : 'disabled'}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text(
              'Status updates automatically when changed in device settings',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
```

## API Reference

### Methods

#### `isScreenReaderEnabled()`

Returns whether the screen reader is currently enabled.

**Returns:** `Future<bool>`
- `true` if screen reader is enabled
- `false` if screen reader is disabled

**Platform behavior:**
- **iOS**: Checks if VoiceOver is running
- **Android**: Checks if TalkBack or other spoken feedback services are enabled

#### `getPlatformVersion()`

Returns the platform version string.

**Returns:** `Future<String?>`

### Streams

#### `screenReaderStatusChanged`

A stream that emits screen reader status changes in real-time.

**Returns:** `Stream<bool>`
- Emits `true` when screen reader is enabled
- Emits `false` when screen reader is disabled

**Platform behavior:**
- **iOS**: Listens to `UIAccessibility.voiceOverStatusDidChangeNotification`
- **Android**: Monitors accessibility settings changes via `AccessibilityStateChangeListener` and `ContentObserver`

## Platform-Specific Information

### iOS

- Uses `UIAccessibility.isVoiceOverRunning` to check VoiceOver status
- Listens to `UIAccessibility.voiceOverStatusDidChangeNotification` for changes
- No additional permissions required
- Works on iOS 9.0+

**Testing on iOS Simulator:**
1. Open Settings app
2. Go to Accessibility > VoiceOver
3. Toggle VoiceOver on/off
4. The plugin will detect changes in real-time

### Android

- Uses `AccessibilityManager` to check TalkBack status
- Monitors multiple accessibility settings for comprehensive detection
- Listens to system broadcasts and content changes
- No additional permissions required
- Works on Android API 16+

**Testing on Android:**
1. Open Settings app
2. Go to Accessibility > TalkBack (or Accessibility > Screen Reader > TalkBack on some devices)
3. Toggle TalkBack on/off
4. The plugin will detect changes in real-time

## Example App

The plugin includes a comprehensive example app that demonstrates:

- Real-time screen reader status detection
- UI updates based on accessibility changes
- Best practices for handling accessibility in Flutter
- Platform-specific instructions for testing

To run the example:

```bash
cd example
flutter run
```

## Testing

Run the unit tests:

```bash
flutter test
```

Run integration tests:

```bash
cd example
flutter test integration_test/
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Clone the repository
2. Run `flutter pub get` in the root directory
3. Run `flutter pub get` in the example directory
4. Make your changes
5. Run tests: `flutter test`
6. Test on both platforms
7. Submit a pull request

## Author

**Yasin Arik**  
🔗 [LinkedIn](https://linkedin.com/in/yasinarik)  
📧 [yasin.ariky@gmail.com](mailto:yasin.ariky@gmail.com)  
🐙 [GitHub](https://github.com/yasinarik)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you have any questions or issues, please [open an issue](https://github.com/yasinarik/device_accessibility_info/issues) on GitHub.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes in each version.

