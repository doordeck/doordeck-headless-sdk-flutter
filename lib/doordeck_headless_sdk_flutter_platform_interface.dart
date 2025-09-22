import 'package:doordeck_headless_sdk_flutter/doordeck_headless_sdk_flutter.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'doordeck_headless_sdk_flutter_method_channel.dart';

/// The abstract platform interface that defines the contract for platform-specific implementations.
///
/// This class uses the `plugin_platform_interface` package to ensure that platform
/// implementations are verified at runtime.
abstract class DoordeckHeadlessSdkFlutterPlatform extends PlatformInterface {
  /// Constructs a DoordeckHeadlessSdkFlutterPlatform.
  DoordeckHeadlessSdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static DoordeckHeadlessSdkFlutterPlatform _instance = MethodChannelDoordeckHeadlessSdkFlutter();

  /// The default instance of [DoordeckHeadlessSdkFlutterPlatform] to use.
  static DoordeckHeadlessSdkFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// class that extends [DoordeckHeadlessSdkFlutterPlatform] when
  /// they register themselves.
  static set instance(DoordeckHeadlessSdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Sets the callback for handling auth token requests from native code.
  void setAuthTokenCallback(AuthTokenCallback callback) {
    throw UnimplementedError('setAuthTokenCallback() has not been implemented.');
  }

  /// Initiates the unlock flow.
  Future<void> unlockFlow() {
    throw UnimplementedError('unlockFlow() has not been implemented.');
  }

  /// Initializes the SDK with the provided authentication token.
  Future<void> initialize({String? authToken}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }
}
