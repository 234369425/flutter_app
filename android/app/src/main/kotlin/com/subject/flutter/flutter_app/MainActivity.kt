package com.subject.flutter.flutter_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry
import io.agora.agorartm.AgoraRtmPlugin
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "io.agora.rtm"


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        val shimPluginRegistry = ShimPluginRegistry(flutterEngine)

        //GeneratedPluginRegistrant.registerWith(flutterEngine)
        flutterEngine.getPlugins().add(io.flutter.plugins.camera.CameraPlugin());
        flutterEngine.getPlugins().add(io.flutter.plugins.connectivity.ConnectivityPlugin());
        com.example.flutterimagecompress.FlutterImageCompressPlugin.registerWith(shimPluginRegistry.registrarFor("com.example.flutterimagecompress.FlutterImageCompressPlugin"));
        flutterEngine.getPlugins().add(io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin());
        flutterEngine.getPlugins().add(io.github.ponnamkarthik.toast.fluttertoast.FlutterToastPlugin());
        flutterEngine.getPlugins().add(io.flutter.plugins.imagepicker.ImagePickerPlugin());
        com.example.last_qr_scanner.LastQrScannerPlugin.registerWith(shimPluginRegistry.registrarFor("com.example.last_qr_scanner.LastQrScannerPlugin"));
        flutterEngine.getPlugins().add(io.flutter.plugins.pathprovider.PathProviderPlugin());
        flutterEngine.getPlugins().add(com.baseflow.permissionhandler.PermissionHandlerPlugin());
        flutterEngine.getPlugins().add(io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin());
        flutterEngine.getPlugins().add(com.tekartik.sqflite.SqflitePlugin());


        /**
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            println(call, result)
        }**/

        AgoraRtmPlugin.registerWith(shimPluginRegistry.registrarFor("io.agora.rtm"))
    }


}
