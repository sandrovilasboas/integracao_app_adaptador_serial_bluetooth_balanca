import 'package:app_balanca/service/bluetooth.dart';
import 'package:app_balanca/widget/connection_state_icon.dart';
import 'package:app_balanca/widget/weight_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [],
  );

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => Bluetooth())],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Integracao Adaptador Bluetooth Balanca',
      theme: ThemeData(colorScheme: ColorScheme.dark()),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget _buildBody() {
    final provider = Provider.of<Bluetooth>(context);
    if (provider.isConnected == false) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WeightText(),
        SizedBox(
          width: 100,
          height: 100,
          child: IconButton.filled(
            onPressed: () => provider.read(),
            icon: Icon(Icons.search),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [ConnectionStateIcon()],
        title: Text('Integracao Adaptador Bluetooth Balanca'),
      ),
      body: Center(child: _buildBody()),
    );
  }
}
