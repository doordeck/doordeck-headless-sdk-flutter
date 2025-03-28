import 'package:doordeck_headless_sdk_flutter/models/assisted_register_ephemeral_key_response.dart';
import 'package:doordeck_headless_sdk_flutter/models/tile_locks_response.dart';
import 'package:doordeck_headless_sdk_flutter/models/user_details_response.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'doordeck_headless_sdk_flutter_method_channel.dart';

abstract class DoordeckHeadlessSdkFlutterPlatform extends PlatformInterface {
  DoordeckHeadlessSdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static DoordeckHeadlessSdkFlutterPlatform _instance = MethodChannelDoordeckHeadlessSdkFlutter();

  /// The default instance of [DoordeckHeadlessSdkFlutterPlatform] to use.
  static DoordeckHeadlessSdkFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DoordeckHeadlessSdkFlutterPlatform] when
  /// they register themselves.
  static set instance(DoordeckHeadlessSdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Login with email and password
  Future<AssistedRegisterEphemeralKeyResponse> login(
      String email,
      String password,
      ) {
    throw UnimplementedError('login() has not been implemented.');
  }

  /// Set the auth token
  Future<AssistedRegisterEphemeralKeyResponse> setAuthToken(
      String authToken,
      ) {
    throw UnimplementedError('setAuthToken() has not been implemented.');
  }

  /// Get user details
  Future<UserDetailsResponse> getUserDetails() {
    throw UnimplementedError('getUserDetails() has not been implemented.');
  }

  /// Verify using the verification code
  Future<void> verify(String code) {
    throw UnimplementedError('verify() has not been implemented.');
  }

  /// Logout
  Future<void> logout() {
    throw UnimplementedError('logout() has not been implemented.');
  }

  /// Get locks belonging to a tile
  Future<TileLocksResponse> getLocksBelongingToTile(String tileId) {
    throw UnimplementedError('getLocksBelongingToTile() has not been implemented.');
  }

  /// Unlock device by lock ID
  Future<void> unlockDevice(String lockId) {
    throw UnimplementedError('unlockDevice() has not been implemented.');
  }
}