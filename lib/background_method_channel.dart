import 'dart:convert';

import 'package:background/background_configuration.dart';
import 'package:background/background_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// An implementation of [BackgroundPlatform] that uses method channels.
class MethodChannelBackground extends BackgroundPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('background');

  @override
  Future<bool> configure(BackgroundConfiguration configuration) => methodChannel
          .invokeMethod<bool>(
        'configurate',
        configuration.toNativeConfiguration().toRawJson(),
      )
          .catchError((Object error) {
        debugPrint(
          '[Background IOS Plugin] Configuration finished with error: $error',
        );
        return null;
      }).then((value) => value ?? false);
}
