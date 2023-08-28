package com.eaapps.share_intent
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
/** ShareIntentPlugin */

class ShareIntentPlugin : FlutterPlugin, ActivityAware, PluginRegistry.NewIntentListener {
  private val channel = "intent_share"
  private val eventChannel = "intent_share/IntentSender"
  private lateinit var methodChannel: MethodChannel

  private lateinit var applicationContext: Context
  private var binding: ActivityPluginBinding? = null

  private var url: String? = null
  private var urlEventSink: EventChannel.EventSink? = null


  private fun setupCallbackChannels(binaryMessenger: BinaryMessenger) {

    methodChannel = MethodChannel(binaryMessenger, channel);
    EventChannel(binaryMessenger, eventChannel).setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        urlEventSink = events;
      }

      override fun onCancel(arguments: Any?) {
        urlEventSink = null
      }

    })
    methodChannel.setMethodCallHandler { call, result ->
      if (call.method == "intentFromOtherApp") {
        url?.apply {
          result.success(mapOf("url" to this))
        }
      }
    }
  }


  private fun handleIntent(intent: Intent) {
    Log.d(TAG, "onNewIntent: SHARE NEW INTENT")
    url = intent.getStringExtra(Intent.EXTRA_TEXT)
    Log.d(TAG, "onNewIntent: $url")
    url?.apply {
      urlEventSink?.success(mapOf("url" to this));
    }
  }

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = binding.applicationContext
    setupCallbackChannels(binding.binaryMessenger)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.binding = binding
    binding.addOnNewIntentListener(this)
    handleIntent(binding.activity.intent)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    binding?.removeOnNewIntentListener(this)
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.binding = binding
    binding.addOnNewIntentListener(this)
  }

  override fun onDetachedFromActivity() {
    binding?.removeOnNewIntentListener(this)
  }

  override fun onNewIntent(intent: Intent): Boolean {
    handleIntent(intent)
    return false
  }


}

private const val TAG = "SHAREINTENT"