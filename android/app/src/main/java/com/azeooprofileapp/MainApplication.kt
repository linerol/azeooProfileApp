package com.azeooprofileapp

import android.app.Application
import com.facebook.react.PackageList
import com.facebook.react.ReactApplication
import com.facebook.react.ReactHost
import com.facebook.react.ReactNativeApplicationEntryPoint.loadReactNative
import com.facebook.react.defaults.DefaultReactHost.getDefaultReactHost
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class MainApplication : Application(), ReactApplication {

  companion object {
    const val PROFILE_ENGINE_ID = "azeoo_profile_engine"
  }

  lateinit var flutterEngine: FlutterEngine

  override val reactHost: ReactHost by lazy {
    getDefaultReactHost(
      context = applicationContext,
      packageList =
        PackageList(this).packages.apply {
          add(ProfilePackage())
        },
    )
  }

  override fun onCreate() {
    super.onCreate()
    loadReactNative(this)
    initFlutterEngine()
  }

  private fun initFlutterEngine() {
    flutterEngine = FlutterEngine(this).also { engine ->
      engine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
      FlutterEngineCache.getInstance().put(PROFILE_ENGINE_ID, engine)
    }
  }
}
