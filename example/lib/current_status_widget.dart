import 'package:flutter/material.dart';

class CurrentStatusWidget extends StatelessWidget {
  final bool? isConnected;

  const CurrentStatusWidget({super.key, this.isConnected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding:  EdgeInsets.zero,
        title: Text(isConnected == true ? 'Connected' : 'Disconnected'),
        trailing: isConnected == true
            ? const Icon(
          Icons.sensors_rounded,
          color: Colors.green,
        )
            : const Icon(
          Icons.sensors_off_rounded,
          color: Colors.red,
        ));
  }
}
