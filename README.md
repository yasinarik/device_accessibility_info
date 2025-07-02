# Device Accessibility Info

[![pub package](https://img.shields.io/pub/v/device_accessibility_info.svg)](https://pub.dev/packages/device_accessibility_info)
[![Platform](https://img.shields.io/badge/platform-flutter-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## Author

**Created by [Yasin Arik](https://linkedin.com/in/yasinarik)** 👨‍💻  
📧 [yasin.ariky@gmail.com](mailto:yasin.ariky@gmail.com)  
🐙 [GitHub](https://github.com/yasinarik)

## About

A Flutter plugin that detects screen reader status and provides real-time change notifications for VoiceOver (iOS) and TalkBack (Android).

## Features

- ✅ **Screen Reader Detection**: Check if VoiceOver/TalkBack is enabled
- ✅ **Real-time Notifications**: Listen for status changes
- ✅ **Cross-platform**: iOS and Android support
- ✅ **Simple API**: Easy integration with Future and Stream methods

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
    _initializeAccessibility();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeAccessibility() async {
    // Check current status
    bool isEnabled = await _plugin.isScreenReaderEnabled();
    
    // Listen for changes
    _subscription = _plugin.screenReaderStatusChanged.listen((isEnabled) {
      setState(() {
        _isScreenReaderEnabled = isEnabled;
      });
    });
    
    setState(() {
      _isScreenReaderEnabled = isEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accessibility Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isScreenReaderEnabled ? Icons.accessibility : Icons.accessibility_outlined,
              size: 64,
              color: _isScreenReaderEnabled ? Colors.green : Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Screen reader is ${_isScreenReaderEnabled ? 'enabled' : 'disabled'}',
              style: Theme.of(context).textTheme.headlineSmall,
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

## Platform Details

| Platform | Screen Reader | Detection Method |
|----------|---------------|------------------|
| iOS      | VoiceOver     | `UIAccessibility.isVoiceOverRunning` |
| Android  | TalkBack      | `AccessibilityManager` + Settings monitoring |

## Testing

### iOS
1. Settings → Accessibility → VoiceOver → Toggle on/off
2. The plugin detects changes in real-time

### Android  
1. Settings → Accessibility → TalkBack → Toggle on/off
2. The plugin detects changes in real-time

## Requirements

- iOS 9.0+
- Android API 16+
- No additional permissions required

## License

MIT License - Copyright (c) 2025 Yasin Arik

## Links

- [GitHub Repository](https://github.com/yasinarik/device_accessibility_info)
- [Issues](https://github.com/yasinarik/device_accessibility_info/issues)
- [Changelog](CHANGELOG.md)

