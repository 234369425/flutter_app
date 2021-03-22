package com.subject.flutter.flutter_app.plugins.rtm

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.Log;

class RTMPlugin : FlutterPlugin {

    private var channel: MethodChannel? = null

    companion object {
        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar) {
            val plugin = RTMPlugin()
            plugin.setupChannel(registrar.messenger(), registrar.context())
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        setupChannel(binding.binaryMessenger, binding.applicationContext)
    }

    override fun onDetachedFromEngine(p0: FlutterPlugin.FlutterPluginBinding) {
        teardownChannel();
    }

    fun setupChannel(messenger: BinaryMessenger, context: Context) {
        Log.i("io.agora.rtm", "setup")
        channel = MethodChannel(messenger, "io.agora.rtm")
        val handler = AgoraRtmPlugin(context, messenger)
        channel?.setMethodCallHandler(handler)
    }

    private fun teardownChannel() {
        channel?.setMethodCallHandler(null)
        channel = null
    }

}
