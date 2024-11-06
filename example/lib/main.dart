import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:soft_connect/soft_connect.dart';
import 'package:soft_connect_example/connection_type_widget.dart';
import 'package:soft_connect_example/current_status_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _softConnectPlugin = SoftConnect();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Text('🔸Method channel', textAlign: TextAlign.left),
              const SizedBox(height: 8),
              FutureBuilder<bool>(
                  future: _checkIsConnected(),
                  builder: (context, snapshot) {
                    return snapshot.data != null
                        ? CurrentStatusWidget(isConnected: snapshot.data)
                        : const CircularProgressIndicator();
                  }),
              FutureBuilder<ConnectionStatus>(
                  future: _getConnectionType(),
                  builder: (context, snapshot) {
                    return snapshot.data != null
                        ? ConnectionTypeWidget(status: snapshot.data)
                        : const CircularProgressIndicator();
                  }),
              const Divider(),
              const SizedBox(height: 8),
              const Text('🔹Event channel', textAlign: TextAlign.left),
              const SizedBox(height: 8),
              StreamBuilder(
                  stream: _softConnectPlugin.onConnectionStatusChanged(),
                  builder: (context, snapshot) {
                    return snapshot.data != null
                        ? ConnectionTypeWidget(status: snapshot.data)
                        : const CircularProgressIndicator();
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {}),
          child: const Icon(Icons.refresh_outlined),
        ),
      ),
    );
  }

  Future<bool> _checkIsConnected() async {
    return await _softConnectPlugin.isConnected();
  }

  Future<ConnectionStatus> _getConnectionType() async {
    return await _softConnectPlugin.getConnectionStatus();
  }
}
