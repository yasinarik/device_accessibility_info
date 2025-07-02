import Flutter
import UIKit

public class DeviceAccessibilityInfoPlugin: NSObject, FlutterPlugin {
    private var eventSink: FlutterEventSink?
    private var methodChannel: FlutterMethodChannel?
    private var eventChannel: FlutterEventChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = DeviceAccessibilityInfoPlugin()
        
        // Method channel for one-time calls
        let methodChannel = FlutterMethodChannel(name: "device_accessibility_info/methods", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        instance.methodChannel = methodChannel
        
        // Event channel for streaming changes
        let eventChannel = FlutterEventChannel(name: "device_accessibility_info/events", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
        instance.eventChannel = eventChannel
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isScreenReaderEnabled":
            result(UIAccessibility.isVoiceOverRunning)
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    deinit {
        stopListening()
    }
}

// MARK: - FlutterStreamHandler
extension DeviceAccessibilityInfoPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        startListening()
        
        // Send initial state
        events(UIAccessibility.isVoiceOverRunning)
        
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        stopListening()
        self.eventSink = nil
        return nil
    }
    
    private func startListening() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(voiceOverStatusChanged),
            name: UIAccessibility.voiceOverStatusDidChangeNotification,
            object: nil
        )
    }
    
    private func stopListening() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIAccessibility.voiceOverStatusDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func voiceOverStatusChanged() {
        DispatchQueue.main.async {
            self.eventSink?(UIAccessibility.isVoiceOverRunning)
        }
    }
}
