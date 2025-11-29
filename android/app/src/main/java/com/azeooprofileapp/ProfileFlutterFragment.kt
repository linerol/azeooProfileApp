package com.azeooprofileapp

import android.os.Bundle
import io.flutter.embedding.android.FlutterFragment
import io.flutter.plugin.common.MethodChannel

class ProfileFlutterFragment : FlutterFragment() {

  companion object {
    private const val ARG_USER_ID = "arg_user_id"
    private const val CHANNEL_NAME = "azeoo/profile"

    fun newInstance(userId: Int): ProfileFlutterFragment {
      return ProfileFlutterFragment().apply {
        arguments = Bundle().apply { putInt(ARG_USER_ID, userId) }
      }
    }
  }

  override fun getCachedEngineId(): String = MainApplication.PROFILE_ENGINE_ID

  override fun onResume() {
    super.onResume()
    sendUserIdToFlutter()
  }

  private fun sendUserIdToFlutter() {
    val targetUserId = arguments?.getInt(ARG_USER_ID) ?: return
    val dartExecutor = flutterEngine?.dartExecutor ?: return

    MethodChannel(dartExecutor, CHANNEL_NAME).invokeMethod(
      "setUserId",
      targetUserId,
    )
  }
}

