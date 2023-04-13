import 'dart:async';
import 'dart:ui';

import 'package:background/background_configuration.dart';
import 'package:background/background_platform_interface.dart';
import 'package:flutter/services.dart';

class Background {
  Future<bool> configure(BackgroundConfiguration configuration) =>
      BackgroundPlatform.instance.configure(configuration);
}

@pragma('vm:entry-point')
Future<void> bgTaskEntrypoint(List<String> args) async {
  DartPluginRegistrant.ensureInitialized();
  final service = IOSBGExecutor();
  final int handle = int.parse(args.first);
  final callbackHandle = CallbackHandle.fromRawHandle(handle);
  final bgTask = PluginUtilities.getCallbackFromHandle(callbackHandle)
      as FutureOr<bool> Function()?;
  if (bgTask != null) {
    final result = await bgTask();
    await service._setBGTaskResult(result);
  }
}

class IOSBGExecutor {
  static const MethodChannel _channel = MethodChannel(
    'background/task_executing',
    JSONMethodCodec(),
  );

  Future<void> _setBGTaskResult(bool value) =>
      _channel.invokeMethod<void>('setBGTaskResult', value);
}
