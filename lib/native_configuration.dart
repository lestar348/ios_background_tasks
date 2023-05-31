import 'dart:convert';

class NativeConfiguration {
  NativeConfiguration({
    required this.refreshTasks,
    required this.processingTasks,
  });

  final List<NativeTaskConfiguration> refreshTasks;
  final List<NativeTaskConfiguration> processingTasks;

  /// Using to pass data
  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'refresh_tasks': refreshTasks.map((x) => x.toJson()).toList(),
        'processing_tasks': processingTasks.map((x) => x.toJson()).toList(),
      };
}

class NativeTaskConfiguration {
  NativeTaskConfiguration({
    required this.identifier,
    required this.rawCallbackHandleId,
    this.rawCancelID,
  });

  final String identifier;
  final int rawCallbackHandleId;
  final int? rawCancelID;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'identifier': identifier,
        'raw_callback_handle_ID': rawCallbackHandleId,
        'raw_cancel_ID': rawCancelID,
      };
}
