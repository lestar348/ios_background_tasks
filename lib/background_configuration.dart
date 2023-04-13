import 'dart:async';
import 'dart:ui';

import 'package:background/native_configuration.dart';
import 'package:flutter/foundation.dart';

const _refreshTaskIdentifier = 'com.vergo.iosBackground.refresh';
const _processingTaskIdentifier = 'com.vergo.iosBackground.ProcessingTask';

enum TaskType {
  refresh,
  processing,
}

class BackgroundConfiguration {
  BackgroundConfiguration({
    required List<BGTask> tasks,
  })  : refreshTasks = tasks
            .where((element) => element.taskType == TaskType.refresh)
            .toList(),
        processingTasks = tasks
            .where((element) => element.taskType == TaskType.processing)
            .toList();

  final List<BGTask> refreshTasks;
  final List<BGTask> processingTasks;

  NativeConfiguration toNativeConfiguration() {
    final nativeRefreshTaskConfs = <NativeTaskConfiguration>[];
    final nativeProcessingTaskConfs = <NativeTaskConfiguration>[];

    for (final task in refreshTasks) {
      final nativeTaskConfiguration = task.toNativeTaskConfiguration();
      if (nativeTaskConfiguration == null) {
        continue;
      }
      nativeRefreshTaskConfs.add(nativeTaskConfiguration);
    }
    for (final task in processingTasks) {
      final nativeTaskConfiguration = task.toNativeTaskConfiguration();
      if (nativeTaskConfiguration == null) {
        continue;
      }
      nativeProcessingTaskConfs.add(nativeTaskConfiguration);
    }
    return NativeConfiguration(
      processingTasks: nativeProcessingTaskConfs,
      refreshTasks: nativeRefreshTaskConfs,
    );
  }
}

class BGTask {
  BGTask({required this.taskName, required this.task, required this.taskType});

  final String taskName;
  final FutureOr<bool> Function() task;
  final TaskType taskType;

  NativeTaskConfiguration? toNativeTaskConfiguration() {
    final rawHandleID = PluginUtilities.getCallbackHandle(task)?.toRawHandle();
    if (rawHandleID == null) {
      debugPrint(
        "[Background IOS Plugin] Can't get rawHandleID for task: $taskName",
      );
      return null;
    }
    return NativeTaskConfiguration(
      identifier: taskType == TaskType.refresh
          ? '$_refreshTaskIdentifier.$taskName'
          : '$_processingTaskIdentifier.$taskName',
      rawCallbackHandleId: rawHandleID,
    );
  }
}
