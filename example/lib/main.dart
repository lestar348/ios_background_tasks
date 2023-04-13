import 'package:background_example/test_bg_configuration.dart';
import 'package:flutter/material.dart';

void main() {
  /// This command was included in [runApp] call since 2.10 for Windows.
  final _ = WidgetsFlutterBinding.ensureInitialized();
  testBGConfiguration();
  runApp(const MyApp());
  // .then((value) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(),
      ),
    );
  }
}
