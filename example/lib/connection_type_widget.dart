import 'package:flutter/material.dart';
import 'package:soft_connect/soft_connect.dart';

class ConnectionTypeWidget extends StatelessWidget {
  final ConnectionStatus? status;

  const ConnectionTypeWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == ConnectionStatus.wifi) {
      return const ListTile(
        contentPadding:  EdgeInsets.zero,
        title: Text('Wifi'),
        trailing: Icon(Icons.wifi_rounded, color: Colors.green),
      );
    } else if (status == ConnectionStatus.mobile) {
      return const ListTile(
        contentPadding:  EdgeInsets.zero,
        title: Text('Mobile'),
        trailing: Icon(Icons.network_cell_rounded, color: Colors.green),
      );
    } else if (status == ConnectionStatus.other) {
      return const ListTile(
        contentPadding:  EdgeInsets.zero,
        title: Text('Other'),
        trailing: Icon(Icons.compare_arrows_rounded, color: Colors.green),
      );
    } else {
      return const ListTile(
        contentPadding:  EdgeInsets.zero,
        title: Text('No networks found'),
        trailing: Icon(Icons.wifi_off_rounded, color: Colors.red),
      );
    }
  }
}
