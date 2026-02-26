package com.example.sleep_sync_app

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import io.flutter.plugin.common.MethodChannel
import android.os.Bundle
import android.util.Log

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.sleep_sync_app/actions"
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        intent?.let { handleIntent(it) }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        val link = intent.getStringExtra("link")
        if (link != null) {
            // Enviamos el link directamente a Flutter por el canal
            flutterEngine?.dartExecutor?.binaryMessenger?.let {
                MethodChannel(it, CHANNEL).invokeMethod("onActionReceived", link)
            }
        }
    }
}