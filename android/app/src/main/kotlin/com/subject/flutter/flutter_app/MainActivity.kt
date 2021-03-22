package com.subject.flutter.flutter_app

import android.os.Bundle
import android.os.PersistableBundle
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        Log.i("main activity on create","on create")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        Log.i("configure flutter engine", " init plugins ")
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        /*
        val shimPluginRegistry = ShimPluginRegistry(flutterEngine)

        //GeneratedPluginRegistrant.registerWith(flutterEngine)
        try {
            ShimPluginRegistry shimPluginRegistry = ShimPluginRegistry(flutterEngine);
            io.agora.agorartm.AgoraRtmPlugin.registerWith(shimPluginRegistry.registrarFor("io.agora.agorartm.AgoraRtmPlugin"));
            flutterEngine.getPlugins().add( io.flutter.plugins.camera.CameraPlugin());
            flutterEngine.getPlugins().add( io.flutter.plugins.connectivity.ConnectivityPlugin());
            flutterEngine.getPlugins().add( com.example.flutterimagecompress.FlutterImageCompressPlugin());
            flutterEngine.getPlugins().add( io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin());
            flutterEngine.getPlugins().add( io.github.ponnamkarthik.toast.fluttertoast.FlutterToastPlugin());
            flutterEngine.getPlugins().add( io.flutter.plugins.imagepicker.ImagePickerPlugin());
            com.example.last_qr_scanner.LastQrScannerPlugin.registerWith(shimPluginRegistry.registrarFor("com.example.last_qr_scanner.LastQrScannerPlugin"));
            flutterEngine.getPlugins().add( io.flutter.plugins.pathprovider.PathProviderPlugin());
            flutterEngine.getPlugins().add( com.baseflow.permissionhandler.PermissionHandlerPlugin());
            flutterEngine.getPlugins().add( io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin());
            flutterEngine.getPlugins().add( com.tekartik.sqflite.SqflitePlugin());
            flutterEngine.getPlugins().add( io.flutter.plugins.videoplayer.VideoPlayerPlugin());
            flutterEngine.getPlugins().add( creativemaybeno.wakelock.WakelockPlugin());
            flutterEngine.getPlugins().add( io.flutter.plugins.webviewflutter.WebViewFlutterPlugin());

        } catch (e: Exception) {
            Log.e("flutter.android.exception", e.toString())
        }*/

    }


}
