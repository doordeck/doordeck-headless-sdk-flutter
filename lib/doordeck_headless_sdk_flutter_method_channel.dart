import 'package:doordeck_headless_sdk_flutter/doordeck_headless_sdk_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'doordeck_headless_sdk_flutter_platform_interface.dart';

/// The method channel implementation of [DoordeckHeadlessSdkFlutterPlatform].
///
/// This class handles communication with the native iOS/Android code.
class MethodChannelDoordeckHeadlessSdkFlutter extends DoordeckHeadlessSdkFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('doordeck_headless_sdk_flutter');

  /// The callback function provided by the user to refresh the auth token.
  AuthTokenCallback? _authTokenCallback;

  MethodChannelDoordeckHeadlessSdkFlutter() {
    methodChannel.setMethodCallHandler(_handleMethod);
  }

  @override
  void setAuthTokenCallback(AuthTokenCallback callback) {
    _authTokenCallback = callback;
  }

  /// Handles incoming method calls from the native side.
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'requiresNewAuthToken':
        if (_authTokenCallback != null) {
          try {
            final String? newAuthToken = await _authTokenCallback!();
            return newAuthToken;
          } catch (e) {
            debugPrint('AuthTokenCallback failed: $e');
            return null;
          }
        } else {
          debugPrint("Warning: Native code requires a new auth token, but no AuthTokenCallback was set.");
          return null;
        }
      default:
        throw MissingPluginException('Not implemented: ${call.method}');
    }
  }

  @override
  Future<void> unlockFlow() async {
    try {
      await methodChannel.invokeMethod('unlockFlow');
    } on PlatformException catch (e) {
      debugPrint("Failed to invoke 'unlockFlow': ${e.message}");
      rethrow;
    }
  }

  @override
  Future<void> initialize({String? authToken}) async {
    try {
      await methodChannel.invokeMethod('initialize', {'authToken': authToken});
    } on PlatformException catch (e) {
      debugPrint("Failed to invoke 'initialize': ${e.message}");
      rethrow;
    }
  }
}
