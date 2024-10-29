package com.example.cypheron

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.cypheron/share"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Sets up the MethodChannel to listen for shared file requests
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSharedFile" -> result.success(getSharedFilePath())
                "openFileAsBytes" -> {
                    val uri = Uri.parse(call.arguments as String)
                    try {
                        val bytes = getFileBytes(uri)
                        if (bytes != null) {
                            result.success(bytes)
                        } else {
                            result.error("UNAVAILABLE", "File not found", null)
                        }
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    // Method to handle the file intent directly from "Open with" action
    private fun handleIntent(intent: Intent?) {
        if (intent?.action == Intent.ACTION_VIEW) {
            intent.data?.let { uri ->
                val path = uri.toString()
                // Use the MethodChannel to send the file path to Flutter
                flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                    MethodChannel(messenger, CHANNEL).invokeMethod("fileReceived", path)
                }
            }
        }
    }

    // Helper function to get the shared file path if requested from Flutter
    private fun getSharedFilePath(): String? {
        return intent?.data?.toString()
    }

    @Throws(Exception::class)
    private fun getFileBytes(uri: Uri): ByteArray? {
        val contentResolver = applicationContext.contentResolver
        contentResolver.openInputStream(uri)?.use { inputStream ->
            return inputStream.readBytes()
        }
        return null
    }
}
