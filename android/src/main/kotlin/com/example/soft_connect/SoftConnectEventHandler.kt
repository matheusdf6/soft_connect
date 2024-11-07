package com.example.soft_connect

import io.flutter.plugin.common.EventChannel

class SoftConnectEventHandler(
  private val connectionManager: ConnectionManager
) : EventChannel.StreamHandler {
  override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink) {
    try {
      connectionManager.listenToConnectionStatus(eventSink)
    } catch (e: Exception) {
      eventSink.error("Exception", e.message, "")
      eventSink.endOfStream()
    }
  }

  override fun onCancel(p0: Any?) {
    connectionManager.stopListeningToConnectionStatus()
  }
}