import 'doordeck_headless_sdk_flutter_platform_interface.dart';

/// Type definition for the auth token callback function.
typedef AuthTokenCallback = Future<String?> Function();

/// The main class for interacting with the Doordeck Headless SDK.
class DoordeckHeadlessSdk {
  final DoordeckHeadlessSdkFlutterPlatform _platform;

  DoordeckHeadlessSdk._(this._platform);

  /// Initializes the Doordeck Headless SDK.
  ///
  /// This must be called before any other method.
  /// [authToken] is the initial authentication token.
  /// [callback] is a function that will be called when a new token is required.
  static Future<DoordeckHeadlessSdk> initialize({
    String? authToken,
    required AuthTokenCallback callback,
  }) async {
    await DoordeckHeadlessSdkFlutterPlatform.instance.initialize(authToken: authToken);
    DoordeckHeadlessSdkFlutterPlatform.instance.setAuthTokenCallback(callback);
    return DoordeckHeadlessSdk._(DoordeckHeadlessSdkFlutterPlatform.instance);
  }

  /// Initiates the unlock flow on the native side.
  Future<void> unlockFlow() {
    return _platform.unlockFlow();
  }
}