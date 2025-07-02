import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:device_accessibility_info/device_accessibility_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _isScreenReaderEnabled = false;
  String _statusMessage = 'Checking...';
  StreamSubscription<bool>? _screenReaderSubscription;
  final _deviceAccessibilityInfoPlugin = DeviceAccessibilityInfo();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initScreenReaderListening();
  }

  @override
  void dispose() {
    _screenReaderSubscription?.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    bool isScreenReaderEnabled;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion =
          await _deviceAccessibilityInfoPlugin.getPlatformVersion() ??
              'Unknown platform version';
      isScreenReaderEnabled =
          await _deviceAccessibilityInfoPlugin.isScreenReaderEnabled();
    } on PlatformException catch (e) {
      platformVersion = 'Failed to get platform version: ${e.message}';
      isScreenReaderEnabled = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _isScreenReaderEnabled = isScreenReaderEnabled;
      _statusMessage = isScreenReaderEnabled
          ? 'Screen reader is enabled'
          : 'Screen reader is disabled';
    });
  }

  void initScreenReaderListening() {
    _screenReaderSubscription =
        _deviceAccessibilityInfoPlugin.screenReaderStatusChanged.listen(
      (bool isEnabled) {
        if (!mounted) return;
        setState(() {
          _isScreenReaderEnabled = isEnabled;
          _statusMessage = isEnabled
              ? 'Screen reader is enabled'
              : 'Screen reader is disabled';
        });
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _statusMessage = 'Error listening to screen reader changes: $error';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Device Accessibility Info'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Platform Information',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text('Running on: $_platformVersion'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Screen Reader Status',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            _isScreenReaderEnabled
                                ? Icons.accessibility
                                : Icons.accessibility_outlined,
                            color: _isScreenReaderEnabled
                                ? Colors.green
                                : Colors.grey,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _statusMessage,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Status updates automatically when changed in device settings',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instructions',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                          '• On iOS: Enable/disable VoiceOver in Settings > Accessibility > VoiceOver'),
                      const Text(
                          '• On Android: Enable/disable TalkBack in Settings > Accessibility > TalkBack'),
                      const SizedBox(height: 8),
                      const Text(
                          'The status will update automatically when you change the setting.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: initPlatformState,
          tooltip: 'Refresh Status',
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
