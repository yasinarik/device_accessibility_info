# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-19

### 🎉 First Stable Release

**Created by [Yasin Arik](https://linkedin.com/in/yasinarik)**

### Added
- **Screen Reader Detection**: Check if VoiceOver (iOS) or TalkBack (Android) is currently enabled
- **Real-time Change Notifications**: Listen for screen reader status changes using event channels
- **iOS Support**: 
  - Uses `UIAccessibility.isVoiceOverRunning` for status detection
  - Listens to `UIAccessibility.voiceOverStatusDidChangeNotification` for changes
- **Android Support**: 
  - Uses `AccessibilityManager` and system settings for TalkBack detection
  - Monitors accessibility changes via `AccessibilityStateChangeListener` and `ContentObserver`
- **Comprehensive API**:
  - `isScreenReaderEnabled()` method for one-time status checks
  - `screenReaderStatusChanged` stream for real-time updates
  - `getPlatformVersion()` method for platform information
- **Example App**: Complete example demonstrating all features with modern UI
- **Unit Tests**: Comprehensive test coverage for all functionality
- **Documentation**: Full API documentation and usage examples

### Platform Support
- iOS 9.0+ (VoiceOver detection)
- Android API 16+ (TalkBack detection)

### Technical Details
- Uses method channels for one-time requests
- Uses event channels for streaming real-time changes
- No additional permissions required on either platform
- Proper resource cleanup and memory management
- Tested on both iOS and Android devices

### Publication Ready
- Ready for pub.dev publication
- Complete documentation and examples
- Stable API design
- Comprehensive testing
