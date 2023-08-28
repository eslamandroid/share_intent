import 'package:flutter/services.dart';

import 'share_intent_platform_interface.dart';

class ShareIntent {
  static ShareIntent instance = ShareIntent._();

  factory ShareIntent() => instance;
  late EventChannel _eventChannel;

  ShareIntent._() {
    _eventChannel = const EventChannel("intent_share/IntentSender");
  }

  Future<String?> getPlatformVersion() {
    return ShareIntentPlatform.instance.getPlatformVersion();
  }

  Stream<Map> getIntentStream() async* {
      yield* _eventChannel.receiveBroadcastStream().asyncMap<Map>((data) => data);
  }
}
