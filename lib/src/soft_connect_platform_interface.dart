import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:soft_connect/src/models/connection_status.dart';

import 'soft_connect_method_channel.dart';

abstract class SoftConnectPlatform extends PlatformInterface {
  /// Constructs a SoftConnectPlatform.
  SoftConnectPlatform() : super(token: _token);

  static final Object _token = Object();

  static SoftConnectPlatform _instance = MethodChannelSoftConnect();

  /// The default instance of [SoftConnectPlatform] to use.
  ///
  /// Defaults to [MethodChannelSoftConnect].
  static SoftConnectPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SoftConnectPlatform] when
  /// they register themselves.
  static set instance(SoftConnectPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> isConnected() {
    throw UnimplementedError('isConnected() has not been implemented.');
  }

  Future<ConnectionStatus> getConnectionStatus() {
    throw UnimplementedError('getConnectionStatus() has not been implemented.');
  }

  Stream<ConnectionStatus> onConnectionStatusChanged() {
    throw UnimplementedError('onConnectionStatusChanged() has not been implemented.');
  }
}
