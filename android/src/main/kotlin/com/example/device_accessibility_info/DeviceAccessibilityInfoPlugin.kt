package com.example.device_accessibility_info

import android.accessibilityservice.AccessibilityServiceInfo
import android.content.Context
import android.database.ContentObserver
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** DeviceAccessibilityInfoPlugin */
class DeviceAccessibilityInfoPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    /// The MethodChannel that will handle communication between Flutter and native Android
    private lateinit var methodChannel: MethodChannel
    
    /// The EventChannel that will stream accessibility changes
    private lateinit var eventChannel: EventChannel
    
    /// Android context
    private lateinit var context: Context
    
    /// AccessibilityManager to check TalkBack status
    private lateinit var accessibilityManager: AccessibilityManager
    
    /// Event sink for streaming changes
    private var eventSink: EventChannel.EventSink? = null
    
    /// Content observer for accessibility services changes
    private var accessibilityServicesObserver: ContentObserver? = null
    
    /// AccessibilityStateChangeListener for API 14+
    private var accessibilityStateChangeListener: AccessibilityManager.AccessibilityStateChangeListener? = null
    
    /// Handler for main thread operations
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        accessibilityManager = context.getSystemService(Context.ACCESSIBILITY_SERVICE) as AccessibilityManager
        
        // Setup method channel
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "device_accessibility_info/methods")
        methodChannel.setMethodCallHandler(this)
        
        // Setup event channel
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "device_accessibility_info/events")
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "isScreenReaderEnabled" -> {
                result.success(isScreenReaderEnabled())
            }
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        stopListening()
    }

    // EventChannel.StreamHandler implementation
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        startListening()
        
        // Send initial state
        eventSink?.success(isScreenReaderEnabled())
    }

    override fun onCancel(arguments: Any?) {
        stopListening()
        eventSink = null
    }

    /**
     * Check if screen reader (TalkBack) is enabled
     */
    private fun isScreenReaderEnabled(): Boolean {
        return try {
            // Check if accessibility is enabled
            if (!accessibilityManager.isEnabled) {
                return false
            }

            // Get enabled accessibility services from system settings
            val enabledServicesSetting = Settings.Secure.getString(
                context.contentResolver,
                Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
            )

            if (enabledServicesSetting.isNullOrEmpty()) {
                return false
            }

            // Check if TalkBack is in the enabled services
            val enabledServices = enabledServicesSetting.split(":")
            enabledServices.any { serviceName ->
                serviceName.contains("talkback", ignoreCase = true) ||
                serviceName.contains("com.google.android.marvin.talkback", ignoreCase = true) ||
                serviceName.contains("com.android.talkback", ignoreCase = true)
            }
        } catch (e: Exception) {
            // Fallback: check for spoken feedback services
            try {
                val enabledServices = accessibilityManager.getEnabledAccessibilityServiceList(
                    AccessibilityServiceInfo.FEEDBACK_SPOKEN
                )
                enabledServices.isNotEmpty()
            } catch (ex: Exception) {
                false
            }
        }
    }

    /**
     * Start listening for accessibility changes
     */
    private fun startListening() {
        // Listen for accessibility state changes using AccessibilityStateChangeListener
        if (accessibilityStateChangeListener == null) {
            accessibilityStateChangeListener = AccessibilityManager.AccessibilityStateChangeListener { enabled ->
                notifyAccessibilityChange()
            }
            accessibilityManager.addAccessibilityStateChangeListener(accessibilityStateChangeListener!!)
        }

        // Listen for changes in enabled accessibility services
        if (accessibilityServicesObserver == null) {
            accessibilityServicesObserver = object : ContentObserver(mainHandler) {
                override fun onChange(selfChange: Boolean, uri: Uri?) {
                    notifyAccessibilityChange()
                }
            }
            
            context.contentResolver.registerContentObserver(
                Settings.Secure.getUriFor(Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES),
                false,
                accessibilityServicesObserver!!
            )
        }
    }

    /**
     * Stop listening for accessibility changes
     */
    private fun stopListening() {
        accessibilityStateChangeListener?.let {
            accessibilityManager.removeAccessibilityStateChangeListener(it)
            accessibilityStateChangeListener = null
        }

        accessibilityServicesObserver?.let {
            context.contentResolver.unregisterContentObserver(it)
            accessibilityServicesObserver = null
        }
    }

    /**
     * Notify Flutter about accessibility changes
     */
    private fun notifyAccessibilityChange() {
        mainHandler.post {
            eventSink?.success(isScreenReaderEnabled())
        }
    }
}
