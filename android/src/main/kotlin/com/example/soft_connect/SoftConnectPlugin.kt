package com.example.soft_connect

import android.content.Context
import android.net.ConnectivityManager

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

/** SoftConnectPlugin */
class SoftConnectPlugin: FlutterPlugin {
  private lateinit var methodChannel : MethodChannel
  private lateinit var eventChannel : EventChannel
  private lateinit var methodHandler: SoftConnectMethodHandler
  private lateinit var eventHandler: SoftConnectEventHandler

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val context = flutterPluginBinding.applicationContext
    val systemConnectivityManager = context.getSystemService(ConnectivityManager::class.java) as ConnectivityManager
    val connectionManager = ConnectionManager(systemConnectivityManager)
    methodHandler = SoftConnectMethodHandler(connectionManager)
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "soft_connect")
    methodChannel.setMethodCallHandler(methodHandler)
    eventHandler = SoftConnectEventHandler(connectionManager)
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "soft_connect/onConnectionStatusChanged")
    eventChannel.setStreamHandler(eventHandler)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }
}
