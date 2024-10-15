import 'package:soft_connect/src/models/connection_status.dart';

import 'soft_connect_platform_interface.dart';

class SoftConnect {
  Future<bool> isConnected() {
    return SoftConnectPlatform.instance.isConnected();
  }

  Future<ConnectionStatus> getConnectionStatus() {
    return SoftConnectPlatform.instance.getConnectionStatus();
  }

  Stream<ConnectionStatus> onConnectionStatusChanged() {
    return SoftConnectPlatform.instance.onConnectionStatusChanged();
  }
}
