package com.example.soft_connect

import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel

const val CONNECTION_TYPE_WIFI = "wifi"
const val CONNECTION_TYPE_MOBILE = "mobile"
const val CONNECTION_TYPE_OTHER = "other"

class ConnectionManager(
  private val connectivityManager: ConnectivityManager
) {
  private val handler = Handler(Looper.getMainLooper())
  private var networkCallback : ConnectivityManager.NetworkCallback? = null

  fun isConnected(result : MethodChannel.Result)  {
    val capabilities = connectivityManager.getNetworkCapabilities(connectivityManager.activeNetwork)
    val isConnected = capabilities != null
            && capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
            && ( capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
              || capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) )
    result.success(isConnected)
  }

  fun getConnectionStatus(result : MethodChannel.Result) {
    val capabilities = getTypeFromCurrentNetwork()
    result.success(capabilities)
  }

  private fun getTypeFromCurrentNetwork() : String? {
    val network = connectivityManager.activeNetwork ?: return null
    return getTypeFromNetwork(network)
  }

  private fun getTypeFromNetwork(network: Network) : String? {
    val capabilities = connectivityManager.getNetworkCapabilities(network)
    return getTypeFromNetworkCapabilities(capabilities)
  }

  private fun getTypeFromNetworkCapabilities(capabilities: NetworkCapabilities?) : String? {
    if(capabilities == null || !capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)) {
      return null
    }

    if(capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) ) {
      return CONNECTION_TYPE_WIFI
    }

    if(capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)) {
      return CONNECTION_TYPE_MOBILE
    }

    return CONNECTION_TYPE_OTHER
  }

  fun listenToConnectionStatus(eventSink: EventSink) {
    networkCallback = object : ConnectivityManager.NetworkCallback() {
      override fun onAvailable(network: Network) {
        super.onAvailable(network)
        val type = getTypeFromNetwork(network)
        sendEvent(eventSink, type)
      }

      override fun onCapabilitiesChanged(
        network: Network,
        networkCapabilities: NetworkCapabilities
      ) {
        super.onCapabilitiesChanged(network, networkCapabilities)
        val type = getTypeFromNetworkCapabilities(networkCapabilities)
        sendEvent(eventSink, type)
      }

      override fun onLost(network: Network) {
        super.onLost(network)
        val type = getTypeFromCurrentNetwork()
        sendEvent(eventSink, type)
      }
    }
    connectivityManager.registerDefaultNetworkCallback(networkCallback!!)
  }

  fun stopListeningToConnectionStatus() {
    if(networkCallback != null) {
      connectivityManager.unregisterNetworkCallback(networkCallback!!)
    }
    networkCallback = null
  }

  private fun sendEvent(eventSink: EventSink, result : Any?) {
    handler.post {
      eventSink.success(result)
    }
  }
}