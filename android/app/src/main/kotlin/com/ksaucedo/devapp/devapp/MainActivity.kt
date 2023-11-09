package com.ksaucedo.devapp.devapp

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import java.util.HashMap
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result


class MainActivity : MethodChannel.MethodCallHandler, EventChannel.StreamHandler,
    FlutterActivity() {
    private var authority: String? = null
    private var receiver: BroadcastReceiver? = null
    private val TAG = "SharedPrefCPPlugin"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "shared_preferences_content_provider"
        ).setMethodCallHandler(this);
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "shared_preferences_content_provider_event"
        ).setMethodCallHandler(this);
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method != Constants.INIT_METHOD) {
            if (authority == null) {
                result.error(
                    "ERROR_NOT_INIT",
                    "SharePreferenceContentProvider must be init before use",
                    null
                )
            }
        }
        when (call.method) {
            Constants.INIT_METHOD -> {
                authority = call.argument("authority")
                result.success("INIT SUCCESS")
                Log.d(TAG, "INIT SUCCESS")
            }

            Constants.GET_METHOD -> {
                result.success(get(call.argument("key")))
                Log.d(TAG, "GET SUCCESS")
            }

            Constants.PUT_STRING_METHOD -> {
                putString(call.argument("key"), call.argument("value"))
                result.success("PUT STRING SUCCESS")
                Log.d(TAG, "PUT SUCCESS")
            }

            Constants.PUT_DOUBLE_METHOD -> {
                putDouble(call.argument("key"), call.argument("value"))
                result.success("PUT DOUBLE SUCCESS")
                Log.d(TAG, "PUT SUCCESS")
            }

            Constants.PUT_BOOL_METHOD -> {
                putBool(call.argument("key"), call.argument("value"))
                result.success("PUT BOOL SUCCESS")
                Log.d(TAG, "PUT SUCCESS")
            }

            Constants.PUT_INT_METHOD -> {
                putInt(call.argument("key"), call.argument("value"))
                result.success("PUT INT SUCCESS")
                Log.d(TAG, "PUT SUCCESS")
            }

            Constants.GET_ALL_METHOD -> {
                result.success(getAll())
                Log.d(TAG, "GET ALL SUCCESS")
            }

            Constants.REMOVE_METHOD -> {
                call(Constants.REMOVE_METHOD, null, null)
                result.success("REMOVE SUCCESS")
                Log.d(TAG, "REMOVE SUCCESS")
            }

            Constants.REMOVE_ALL_METHOD -> {
                call(Constants.REMOVE_ALL_METHOD, null, null)
                result.success("REMOVE ALL SUCCESS")
                Log.d(TAG, "REMOVE ALL SUCCESS")
            }
        }
    }

    private fun putString(key: String?, value: String?) {
        val bundle = Bundle()
        bundle.putString(key, value)
        put(Constants.PUT_STRING_METHOD, key, bundle)
    }


    private fun putDouble(key: String?, value: Double?) {
        val bundle = Bundle()
        bundle.putDouble(key, value!!)
        put(Constants.PUT_DOUBLE_METHOD, key, bundle)
    }

    private fun putBool(key: String?, value: Boolean?) {
        val bundle = Bundle()
        bundle.putBoolean(key, value!!)
        put(Constants.PUT_BOOL_METHOD, key, bundle)
    }

    private fun putInt(key: String?, value: Int?) {
        val bundle = Bundle()
        bundle.putInt(key, value!!)
        put(Constants.PUT_INT_METHOD, key, bundle)
    }


    private fun put(method: String, key: String?, bundle: Bundle) {
        if (receiver != null) {
            val intent = Intent()
            intent.action = Constants.ACTION_DATA_UPDATE
            bundle.putString("key", key)
            intent.putExtras(bundle)
            context.sendBroadcast(intent)
            Log.d(TAG, "SEND BROAD CAST SUCCESS")
        }
        call(method, key, bundle)
    }


    private operator fun get(key: String?): Any? {
        return call(Constants.GET_METHOD, key, null)!![key]
    }

    private fun getAll(): Any? {
        return call(Constants.GET_ALL_METHOD, null, null)!!["data"]
    }

    private fun call(method: String, arg: String?, extras: Bundle?): Bundle? {
        val uri = Uri.parse("content://$authority")
        val cr = context.contentResolver
        val bundle: Bundle? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            cr.call(authority!!, method, arg, extras)
        } else {
            cr.call(uri, method, arg, extras)
        }
        return bundle
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val res: MutableMap<String, Any?> = HashMap()
                res["key"] = intent.extras!!["key"]
                res["value"] = intent.extras!![intent.extras!!["key"] as String?]
                if (arguments != null) {
                    if (arguments == intent.extras!!["key"]) {
                        events.success(res)
                        Log.d(TAG, "RECEIVER $res")
                    }
                } else {
                    events.success(res)
                    Log.d(TAG, "RECEIVER $res")
                }
            }
        }
        context.registerReceiver(receiver, IntentFilter(Constants.ACTION_DATA_UPDATE))
        Log.d(TAG, "LISTENING...")
    }

    override fun onCancel(arguments: Any?) {
        context.unregisterReceiver(receiver)
        receiver = null
        Log.d(TAG, "STOP LISTEN")
    }

}
