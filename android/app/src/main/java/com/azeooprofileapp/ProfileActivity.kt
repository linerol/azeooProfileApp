package com.azeooprofileapp

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity

class ProfileActivity : AppCompatActivity() {

  companion object {
    const val EXTRA_USER_ID = "extra_user_id"
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    val userId = intent.getIntExtra(EXTRA_USER_ID, -1)
    if (userId <= 0) {
      finish()
      return
    }

    if (savedInstanceState == null) {
      supportFragmentManager
        .beginTransaction()
        .replace(
          android.R.id.content,
          ProfileFlutterFragment.newInstance(userId),
          ProfileFlutterFragment::class.java.simpleName,
        )
        .commit()
    }
  }
}

