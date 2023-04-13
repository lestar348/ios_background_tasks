import 'package:background/background_configuration.dart';
import 'package:background/background_method_channel.dart';
import 'package:background/background_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBackgroundPlatform
    with MockPlatformInterfaceMixin
    implements BackgroundPlatform {
  @override
  Future<bool> configure(BackgroundConfiguration configuration) =>
      Future.value(true);
}

void main() {
  final BackgroundPlatform initialPlatform = BackgroundPlatform.instance;

  test('$MethodChannelBackground is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBackground>());
  });
}
