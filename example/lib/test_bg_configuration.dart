import 'dart:async';
import 'dart:ui';

import 'package:background/background.dart';
import 'package:background/background_configuration.dart';

Future<void> testBGConfiguration() {
  final config = BackgroundConfiguration(tasks: [
    BGTask(
        taskName: 'testRefresh',
        taskType: TaskType.refresh,
        task: testRefreshFunc),
    BGTask(
        taskName: 'testProcessing',
        taskType: TaskType.processing,
        task: testProcessingFunc)
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
