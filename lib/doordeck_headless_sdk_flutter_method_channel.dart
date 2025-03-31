import 'package:doordeck_headless_sdk_flutter/models/assisted_register_ephemeral_key_response.dart';
import 'package:doordeck_headless_sdk_flutter/models/tile_locks_response.dart';
import 'package:doordeck_headless_sdk_flutter/models/user_details_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'doordeck_headless_sdk_flutter_platform_interface.dart';

class MethodChannelDoordeckHeadlessSdkFlutter extends DoordeckHeadlessSdkFlutterPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('doordeck_headless_sdk_flutter');

  @override
  Future<AssistedRegisterEphemeralKeyResponse> login(
      String email, String password) async {
    final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
      'login',
      {
        'email': email,
        'password': password,
      },
    );

    return AssistedRegisterEphemeralKeyResponse.fromMap(
        Map<String, dynamic>.from(result!));
  }

  @override
  Future<AssistedRegisterEphemeralKeyResponse> setAuthToken(
      String authToken) async {
    final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
      'setAuthToken',
      {'authToken': authToken},
    );

    return AssistedRegisterEphemeralKeyResponse.fromMap(
        Map<String, dynamic>.from(result!));
  }

  @override
  Future<UserDetailsResponse> getUserDetails() async {
    final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
      'getUserDetails',
    );

    return UserDetailsResponse.fromMap(Map<String, dynamic>.from(result!));
  }

  @override
  Future<void> verify(String code) async {
    await methodChannel.invokeMethod<void>(
      'verify',
      {'code': code},
    );
  }

  @override
  Future<void> logout() async {
    await methodChannel.invokeMethod<void>('logout');
  }

  @override
  Future<TileLocksResponse> getLocksBelongingToTile(String tileId) async {
    final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
      'getLocksBelongingToTile',
      {'tileId': tileId},
    );

    return TileLocksResponse.fromMap(Map<String, dynamic>.from(result!));
  }

  @override
  Future<void> unlockDevice(String lockId) async {
    await methodChannel.invokeMethod<void>(
      'unlockDevice',
      {'lockId': lockId},
    );
  }
}