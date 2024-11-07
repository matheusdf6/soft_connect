package com.example.soft_connect

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class SoftConnectMethodHandler(
  private val connectionManager: ConnectionManager
) : MethodCallHandler {
  override fun onMethodCall(method: MethodCall, result: MethodChannel.Result) {
    when(method.method) {
      "isConnected" -> connectionManager.isConnected(result)
      "getConnectionStatus" -> connectionManager.getConnectionStatus(result)
      else -> result.error("ArgumentError", "Method ${method.method} not implemented", "")
    }
  }
}