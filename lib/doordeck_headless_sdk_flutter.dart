import 'package:doordeck_headless_sdk_flutter/models/assisted_register_ephemeral_key_response.dart';
import 'package:doordeck_headless_sdk_flutter/models/tile_locks_response.dart';
import 'package:doordeck_headless_sdk_flutter/models/user_details_response.dart';

import 'doordeck_headless_sdk_flutter_platform_interface.dart';

class DoordeckHeadlessSdkFlutter {
  static Future<AssistedRegisterEphemeralKeyResponse> login(
    String email,
    String password,
  ) {
    return DoordeckHeadlessSdkFlutterPlatform.instance.login(email, password);
  }

  static Future<AssistedRegisterEphemeralKeyResponse> setAuthToken(
    String authToken,
  ) {
    return DoordeckHeadlessSdkFlutterPlatform.instance.setAuthToken(authToken);
  }

  static Future<UserDetailsResponse> getUserDetails() {
    return DoordeckHeadlessSdkFlutterPlatform.instance.getUserDetails();
  }

  static Future<void> verify(String code) {
    return DoordeckHeadlessSdkFlutterPlatform.instance.verify(code);
  }

  static Future<void> logout() {
    return DoordeckHeadlessSdkFlutterPlatform.instance.logout();
  }

  static Future<TileLocksResponse> getLocksBelongingToTile(String tileId) {
    return DoordeckHeadlessSdkFlutterPlatform.instance.getLocksBelongingToTile(tileId);
  }

  static Future<void> unlockDevice(String lockId) {
    return DoordeckHeadlessSdkFlutterPlatform.instance.unlockDevice(lockId);
  }
}
