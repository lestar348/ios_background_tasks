import 'dart:convert';

class NativeConfiguration {
  NativeConfiguration({
    required this.refreshTasks,
    required this.processingTasks,
  });

  factory NativeConfiguration.fromRawJson(String str) =>
      NativeConfiguration.fromJson(json.decode(str) as Map<String, dynamic>);

  factory NativeConfiguration.fromJson(Map<String, dynamic> json) =>
      NativeConfiguration(
        refreshTasks:
            (json['refresh_tasks'] as List<Map<String, dynamic>>? ?? [])
                .map(NativeTaskConfiguration.fromJson)
                .toList(),
        processingTasks:
            (json['processing_tasks'] as List<Map<String, dynamic>>? ?? [])
                .map(NativeTaskConfiguration.fromJson)
                .toList(),
      );

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
  });

  factory NativeTaskConfiguration.fromRawJson(String str) =>
      NativeTaskConfiguration.fromJson(
          json.decode(str) as Map<String, dynamic>);

  factory NativeTaskConfiguration.fromJson(Map<String, dynamic> json) =>
      NativeTaskConfiguration(
        identifier: json['identifier'] as String,
        rawCallbackHandleId: json['raw_callback_handle_ID'] as int,
      );

  final String identifier;
  final int rawCallbackHandleId;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'identifier': identifier,
        'raw_callback_handle_ID': rawCallbackHandleId,
      };
}
