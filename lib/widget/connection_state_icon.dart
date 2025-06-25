import 'package:app_balanca/service/bluetooth.dart';
import 'package:app_balanca/widget/devices_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectionStateIcon extends StatefulWidget {
  const ConnectionStateIcon({super.key});

  @override
  State<ConnectionStateIcon> createState() => _ConnectionStateIconState();
}

class _ConnectionStateIconState extends State<ConnectionStateIcon> {
  Future<void> _showDevices(Bluetooth provider) async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: DevicesList(
          onTap: (device) async {
            await provider.connect(device.address);

            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }

  Future<void> _turnOnOff(Bluetooth provider) async {
    if (provider.isConnected) {
      await provider.disconnect();
    } else {
      if (provider.address.isEmpty) {
        await _showDevices(provider);
      } else {
        provider.connect(provider.address);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Bluetooth>(context);
    return TextButton.icon(
      label: Text(provider.address),
      onPressed: () => _turnOnOff(provider),
      onLongPress: () => _showDevices(provider),
      icon: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: provider.isConnected ? Icon(Icons.power) : Icon(Icons.power_off),
      ),
    );
  }
}
