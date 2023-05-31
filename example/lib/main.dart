import 'dart:async';
import 'dart:ui';

import 'package:background/background.dart';
import 'package:background/background_configuration.dart';
import 'package:flutter/material.dart';

void main() {
  /// This command was included in [runApp] call since 2.10 for Windows.
  final _ = WidgetsFlutterBinding.ensureInitialized();
  //testBGConfiguration();
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
        body: Center(
          child: Column(
            children: [
              TextButton(
                  onPressed: () => configurateBGTasks(),
                  child: Text('Configurate')),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> configurateBGTasks() {
  final config = BackgroundConfiguration(tasks: [
    BGTask(
      taskName: 'testRefresh',
      taskType: TaskType.refresh,
      //cancelTask: cancelProcessingTask,
      task: testRefreshFunc,
    ),
    BGTask(
      taskName: 'testProcessing',
      taskType: TaskType.processing,
      //cancelTask: cancelProcessingTask,
      task: testProcessingFunc,
    )
  ]);

  return Background().configure(config).then((print));
}

FutureOr<bool> testRefreshFunc() {
  DartPluginRegistrant.ensureInitialized();
  print('I am a REFRESH task');
  return true;
}

FutureOr<bool> testProcessingFunc() {
  DartPluginRegistrant.ensureInitialized();
  print('I am a PROCESSING task');
  return true;
}
