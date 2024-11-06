import Flutter
import UIKit
import Network

public class SoftConnectPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

    //MARK: Config
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "soft_connect", binaryMessenger: registrar.messenger())

        let eventChannel = FlutterEventChannel(name: "soft_connect/onConnectionStatusChanged", binaryMessenger: registrar.messenger())

        let instance = SoftConnectPlugin()
        eventChannel.setStreamHandler(instance)
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }

    // MARK: Handle method channel
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isConnected":
            isConnected(result: result)
        case "getConnectionStatus":
            getConnectionType(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func isConnected(result: @escaping FlutterResult) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)

        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    return result(true)
                } else {
                    return result(false)
                }
            }
        }
        monitor.cancel()
    }


    private func getConnectionType(result: @escaping FlutterResult) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)

        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    if path.usesInterfaceType(.wifi) {
                        result("wifi")
                    } else if path.usesInterfaceType(.cellular) {
                        result("mobile")
                    } else {
                        result("other")
                    }
                } else {
                    return result(nil)
                }
            }
        }
        monitor.cancel()
    }

    // MARK: Event channel
    var connectionMonitor: NWPathMonitor?
    var connectionEventSink: FlutterEventSink?

   public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
       connectionEventSink = events
       monitorConnectionState(eventSink: events)
       return nil
   }

   public func onCancel(withArguments arguments: Any?) -> FlutterError? {
       connectionMonitor?.cancel()
       connectionMonitor = nil
       connectionEventSink = nil
       return nil
   }


   private func monitorConnectionState(eventSink: @escaping FlutterEventSink) {
       connectionMonitor = NWPathMonitor()
       let queue = DispatchQueue(label: "NetworkMonitor")
       connectionMonitor?.start(queue: queue)

       connectionMonitor?.pathUpdateHandler = { path in
           DispatchQueue.main.async {
               if path.status == .satisfied {
                   if path.usesInterfaceType(.wifi) {
                       eventSink("wifi")
                   } else if path.usesInterfaceType(.cellular) {
                       eventSink("mobile")
                   } else {
                       eventSink("other")
                   }
               } else {
                    eventSink(nil)
               }
           }
       }
   }
}
