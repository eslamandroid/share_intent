import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'share_intent_platform_interface.dart';

/// An implementation of [ShareIntentPlatform] that uses method channels.
class MethodChannelShareIntent extends ShareIntentPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('share_intent');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
