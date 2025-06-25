import 'dart:convert';
import 'package:app_balanca/service/bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeightText extends StatefulWidget {
  const WeightText({super.key});

  @override
  State<WeightText> createState() => _WeightTextState();
}

class _WeightTextState extends State<WeightText> {
  String _formatWeight(String weight) {
    if (weight.isEmpty) return "";
    String cleanHex = weight.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
    final weightDouble = int.parse(cleanHex) / 1000;

    return "${weightDouble.toStringAsFixed(3)} KG";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Bluetooth>(context);
    return StreamBuilder(
      stream: provider.readerStream,
      builder: (context, snapshot) {
        if ((snapshot.data ?? []).isEmpty) return SizedBox();

        final weight = utf8.decode(snapshot.data!);
        return Text(
          _formatWeight(weight),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 120, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
