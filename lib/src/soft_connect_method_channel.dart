import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:soft_connect/src/errors/soft_connect_exception.dart';
import 'package:soft_connect/src/models/connection_status.dart';

import 'soft_connect_platform_interface.dart';

/// An implementation of [SoftConnectPlatform] that uses method channels.
class MethodChannelSoftConnect extends SoftConnectPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('soft_connect');

  @visibleForTesting
  final eventChannel = const EventChannel('soft_connect/onConnectionStatusChanged');

  @override
  Future<bool> isConnected() async {
    try {
      return await methodChannel.invokeMethod<bool>('isConnected') == true;
    } on PlatformException catch (e, stackTrace) {
      throw SoftConnectException(
        message: e.message ?? 'An error occured while checking the connection status',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<ConnectionStatus> getConnectionStatus() async {
    try {
      final code = await methodChannel.invokeMethod<String?>('getConnectionStatus');
      return ConnectionStatus.withCode(code);
    } on PlatformException catch (e, stackTrace) {
      throw SoftConnectException(
        message: e.message ?? 'An error occured while checking the connection status',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Stream<ConnectionStatus> onConnectionStatusChanged() {
    final transformer = StreamTransformer<dynamic, ConnectionStatus>.fromHandlers(
      handleData: (data, sink) {
        sink.add(ConnectionStatus.withCode(data));
      },
      handleError: (error, stackTrace, sink) {
        sink.addError(SoftConnectException(message: error.toString(), stackTrace: stackTrace), stackTrace);
      },
    );
    return eventChannel.receiveBroadcastStream().transform(transformer);
  }
}
