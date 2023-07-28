package com.example.dcs_app

import android.accounts.AccountManager
import android.content.Context
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private lateinit var channel: MethodChannel


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.dcs_app"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAllAccounts" -> result.success((getAllAccounts()))
                else -> result.notImplemented()
            }
        }
    }

    private fun getAllAccounts(): MutableList<HashMap<String, String>> {
        val list = mutableListOf<HashMap<String, String>>()
        val manager = context.getSystemService(Context.ACCOUNT_SERVICE) as AccountManager;
        val accounts = manager.accounts;

        println("PrintingAccounts: " + accounts.size)
        for (a in accounts) {
            System.err.println("AccountName: " + a.name)
        }

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

    companion object {
        private const val ACCOUNT_NAME = "account_name"
        private const val ACCOUNT_TYPE = "account_type"
    }
}
