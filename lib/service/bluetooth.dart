import 'dart:async';
import 'dart:typed_data';
import 'package:app_balanca/utils/string_to_bytes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bluetooth extends ChangeNotifier {
  final _bluetooth = FlutterBlueClassic();
  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();
  BluetoothConnection? _connection;
  String? _address;
  Stream<Uint8List>? get readerStream => _connection?.input;
  bool get isConnected => _connection != null ? true : false;
  String get address => _address ?? '';

  Bluetooth() {
    init();
  }

  void init() async {
    final address = await _asyncPrefs.getString("address");
    _address = address;
    if (address != null) {
      _connection = await _bluetooth.connect(address);
      notifyListeners();
    }
  }

  Future<List<BluetoothDevice>> scan() async {
    final List<BluetoothDevice> devices = [];
    _bluetooth.startScan();
    _bluetooth.scanResults.listen((result) {
      devices.add(result);
    });

    await Future.delayed(Duration(seconds: 8), () => _bluetooth.stopScan());

    return devices;
  }

  Future<void> connect(String address) async {
    _connection = await _bluetooth.connect(address);
    _address = address;
    if (_connection != null) {
      await _asyncPrefs.setString("address", address);
    }

    notifyListeners();
  }

  Future<void> disconnect() async {
    await _connection?.finish();
    _connection = null;

    notifyListeners();
  }

  void read() {
    if (!_connection!.isConnected) {
      disconnect();

      return;
    }

    final data = StringToBytes.transform("05");
    _connection?.output.add(data);
  }

  @override
  void dispose() async {
    super.dispose();
    await disconnect();

    _connection?.dispose();
  }
}
