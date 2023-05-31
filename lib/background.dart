import 'dart:async';
import 'dart:ui';

import 'package:background/background_configuration.dart';
import 'package:background/background_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class Background {
  Future<bool> configure(BackgroundConfiguration configuration) =>
      BackgroundPlatform.instance.configure(configuration);
}

class _$BackgroundBinding = BindingBase with SchedulerBinding, ServicesBinding;

@pragma('vm:entry-point')
Future<void> bgTaskEntrypoint(List<String> args) async {
  // ignore: unused_local_variable
  final bindinng = _$BackgroundBinding();
  final service = IOSBGExecutor._();
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
  IOSBGExecutor._() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static const MethodChannel _channel = MethodChannel(
    'background/task_executing',
    JSONMethodCodec(),
  );

  Future<void> _handleMethodCall(MethodCall call) {
    switch (call.method) {
      case 'cancel_task':
        final handle = int.tryParse(call.arguments as String);
        if (handle != null) {
          return cancelTask(handle);
        }
        return _setCanelTaskResult(false);

      default:
        return Future.value();
    }
  }

  Future<void> cancelTask(int handleID) async {
    final callbackHandle = CallbackHandle.fromRawHandle(handleID);
    final bgTask = PluginUtilities.getCallbackFromHandle(callbackHandle)
        as FutureOr<bool> Function()?;
    if (bgTask != null) {
      final result = await bgTask();
      return _setCanelTaskResult(result);
    }
  }

  Future<void> _setCanelTaskResult(bool value) =>
      _channel.invokeMethod<void>('setCanelTaskResult', value);

  Future<void> _setBGTaskResult(bool value) =>
      _channel.invokeMethod<void>('setBGTaskResult', value);
}
