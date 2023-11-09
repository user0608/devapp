package com.ksaucedo.devapp.devapp

import android.content.ContentProvider
import android.content.ContentValues
import android.content.Context
import android.content.SharedPreferences
import android.database.Cursor
import android.net.Uri
import android.os.Bundle
import android.util.Log
import org.json.JSONObject


class SharedPreferencesContentProvider : ContentProvider() {
    private var prefs: SharedPreferences? = null
    override fun onCreate(): Boolean {
        if (context != null) {
            prefs = context!!.getSharedPreferences(SHARE_PREFERENCES, Context.MODE_PRIVATE)
        }
        Log.d(TAG, "context is null")
        return false
    }

    override fun query(
        uri: Uri,
        projection: Array<String>?,
        selection: String?,
        selectionArgs: Array<String>?,
        sortOrder: String?
    ): Cursor? {
        return null
    }

    override fun getType(uri: Uri): String? {
        return null
    }

    override fun insert(uri: Uri, values: ContentValues?): Uri? {
        return null
    }

    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<String>?): Int {
        return 0
    }

    override fun update(
        uri: Uri,
        values: ContentValues?,
        selection: String?,
        selectionArgs: Array<String>?
    ): Int {
        return 0
    }

    override fun call(method: String, arg: String?, extras: Bundle?): Bundle? {
        val bundle = Bundle()
        when (method) {
            Constants.GET_METHOD -> {
                try {
                    val value = get(arg, Boolean::class.java)!!
                    bundle.putBoolean(arg, value)
                } catch (ignored: ClassCastException) {
                }
                try {
                    val value = get(arg, Int::class.java)!!
                    bundle.putInt(arg, value)
                } catch (ignored: ClassCastException) {
                }
                try {
                    val value = get(arg, Double::class.java)!!
                    bundle.putDouble(arg, value)
                } catch (ignored: ClassCastException) {
                }
                try {
                    val value = get(arg, String::class.java)!!
                    bundle.putString(arg, value)
                } catch (ignored: ClassCastException) {
                }
            }

            Constants.PUT_STRING_METHOD -> {
                put(arg, extras!!.getString(arg))
            }

            Constants.PUT_BOOL_METHOD -> {
                put(arg, extras!!.getBoolean(arg))
            }

            Constants.PUT_INT_METHOD -> {
                put(arg, extras!!.getInt(arg))
            }

            Constants.PUT_DOUBLE_METHOD -> {
                put(arg, extras!!.getDouble(arg))
            }

            Constants.GET_ALL_METHOD -> {
                bundle.putString("data", JSONObject(prefs!!.all).toString())
            }

            Constants.REMOVE_METHOD -> {
                prefs!!.edit().remove(arg).apply()
            }

            Constants.REMOVE_ALL_METHOD -> {
                prefs!!.edit().clear().apply()
            }
        }
        return bundle
    }

    operator fun <T> get(key: String?, anonymousClass: Class<T>): T? {
        return if (anonymousClass == String::class.java) {
            prefs!!.getString(key, "") as T?
        } else if (anonymousClass == Boolean::class.java) {
            java.lang.Boolean.valueOf(prefs!!.getBoolean(key, false)) as T
        } else if (anonymousClass == Double::class.java) {
            java.lang.Double.valueOf(
                java.lang.Float.valueOf(prefs!!.getFloat(key, 0f)).toString()
            ) as T
        } else if (anonymousClass == Int::class.java) {
            Integer.valueOf(prefs!!.getInt(key, 0)) as T
        } else {
            null
        }
    }

    fun <T> put(key: String?, data: T) {
        val editor = prefs!!.edit()
        if (data is String) {
            editor.putString(key, data as String)
        } else if (data is Boolean) {
            editor.putBoolean(key, (data as Boolean))
        } else if (data is Double) {
            editor.putFloat(key, (data as Double).toFloat())
        } else if (data is Int) {
            editor.putInt(key, (data as Int))
        }
        editor.apply()
    }

    companion object {
        private const val SHARE_PREFERENCES = "_____share_preferences_____"
        private val TAG = SharedPreferencesContentProvider::class.java.name
    }
}
