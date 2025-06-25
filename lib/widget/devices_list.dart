import 'package:app_balanca/service/bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:provider/provider.dart';

class DevicesList extends StatelessWidget {
  const DevicesList({super.key, required this.onTap});
  final void Function(BluetoothDevice device) onTap;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Bluetooth>(context);
    return FutureBuilder(
      future: provider.scan(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Falha ao listar dispositivos"));
        }

        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            final device = snapshot.data![index];
            return ListTile(
              title: Text(device.name ?? "Desconhecido"),
              subtitle: Text("${device.address} - ${device.type.name}"),
              onTap: () => onTap(device),
            );
          },
        );
      },
    );
  }
}
