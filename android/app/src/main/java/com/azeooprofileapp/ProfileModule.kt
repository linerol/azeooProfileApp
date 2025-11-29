package com.azeooprofileapp

import android.content.Intent
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

class ProfileModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String = "ProfileModule"

  @ReactMethod
  fun openProfileScreen(userId: Int, promise: Promise) {
    if (userId <= 0) {
      promise.reject(IllegalArgumentException("userId must be > 0"))
      return
    }

    val activity = reactApplicationContext.currentActivity ?: run {
      promise.reject(IllegalStateException("Activity is null"))
      return
    }

    val intent = Intent(activity, ProfileActivity::class.java).apply {
      putExtra(ProfileActivity.EXTRA_USER_ID, userId)
    }
    activity.startActivity(intent)
    promise.resolve(null)
  }
}

