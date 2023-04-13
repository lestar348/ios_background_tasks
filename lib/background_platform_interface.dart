import 'package:background/background_configuration.dart';
import 'package:background/background_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class BackgroundPlatform extends PlatformInterface {
  /// Constructs a BackgroundPlatform.
  BackgroundPlatform() : super(token: _token);

  static final Object _token = Object();

  static BackgroundPlatform _instance = MethodChannelBackground();

  /// The default instance of [BackgroundPlatform] to use.
  ///
  /// Defaults to [MethodChannelBackground].
  static BackgroundPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BackgroundPlatform] when
  /// they register themselves.
  static set instance(BackgroundPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> configure(BackgroundConfiguration configuration) {
    throw UnimplementedError('configure() has not been implemented.');
  }
}
