import 'package:flutter_test/flutter_test.dart';
import 'package:share_intent/share_intent.dart';
import 'package:share_intent/share_intent_platform_interface.dart';
import 'package:share_intent/share_intent_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockShareIntentPlatform
    with MockPlatformInterfaceMixin
    implements ShareIntentPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ShareIntentPlatform initialPlatform = ShareIntentPlatform.instance;

  test('$MethodChannelShareIntent is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelShareIntent>());
  });

  test('getPlatformVersion', () async {
    ShareIntent shareIntentPlugin = ShareIntent();
    MockShareIntentPlatform fakePlatform = MockShareIntentPlatform();
    ShareIntentPlatform.instance = fakePlatform;

    expect(await shareIntentPlugin.getPlatformVersion(), '42');
  });
}
