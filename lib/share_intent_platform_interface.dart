import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'share_intent_method_channel.dart';

abstract class ShareIntentPlatform extends PlatformInterface {
  /// Constructs a ShareIntentPlatform.
  ShareIntentPlatform() : super(token: _token);

  static final Object _token = Object();

  static ShareIntentPlatform _instance = MethodChannelShareIntent();

  /// The default instance of [ShareIntentPlatform] to use.
  ///
  /// Defaults to [MethodChannelShareIntent].
  static ShareIntentPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ShareIntentPlatform] when
  /// they register themselves.
  static set instance(ShareIntentPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
