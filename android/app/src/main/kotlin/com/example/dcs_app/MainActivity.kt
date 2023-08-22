package com.example.dcs_app

import android.R
import android.accounts.AccountManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.annotation.RequiresApi
import com.google.android.gms.common.AccountPicker
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Arrays


class MainActivity : FlutterActivity() {
    private lateinit var channel: MethodChannel

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                "com.example.dcs_app"
        )
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getAllAccounts" -> result.success((getAllAccounts()))
                "pickAccount" -> result.success(pickAccount());
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun pickAccount(): Boolean {
        return try {
            val intent = AccountManager.newChooseAccountIntent(null, null, arrayOf("com.google"), null, null, null, null)
            startActivityForResult(intent, 5001);
            true
        } catch (e: Exception) {
            Log.e("Error:", e.message.toString());
            false
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun getAllAccounts(): MutableList<HashMap<String, String>> {
        val list = mutableListOf<HashMap<String, String>>()
        val manager = context.getSystemService(Context.ACCOUNT_SERVICE) as AccountManager;
        val accounts = manager.getAccountsByType(null);
        try {
            for (account in accounts) {
                list.add(
                        hashMapOf(
                                ACCOUNT_NAME to account.name,
                                ACCOUNT_TYPE to account.type
                        )
                )
            }
        } catch (e: Exception) {
            Log.e("Error:", e.message.toString());
        }
        return list;
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode != RESULT_CANCELED) {
            if (resultCode == RESULT_OK && requestCode == 5001) {
                if (data != null) {
                    channel.invokeMethod("account", hashMapOf(
                            ACCOUNT_NAME to data.getStringExtra(AccountManager.KEY_ACCOUNT_NAME),
                            ACCOUNT_TYPE to data.getStringExtra(AccountManager.KEY_ACCOUNT_TYPE),
                    ))

                }
            }
        }
    }

    companion object {
        private const val ACCOUNT_NAME = "account_name"
        private const val ACCOUNT_TYPE = "account_type"
    }
}
