import 'package:doordeck_headless_sdk_flutter/models/assisted_register_ephemeral_key_response.dart';
import 'package:flutter/services.dart';

class ApiClient {
  static const _channel = MethodChannel('doordeck_headless_sdk_flutter');

  static Future<AssistedRegisterEphemeralKeyResponse> login(
    String email,
    String password,
  ) async {
    final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'login',
      {
        'email': email,
        'password': password,
      },
    );

    return AssistedRegisterEphemeralKeyResponse.fromMap(
      Map<String, dynamic>.from(result!),
    );
  }

  static Future<AssistedRegisterEphemeralKeyResponse> setAuthToken(
    String token,
  ) async {
    final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'setAuthToken',
      {'authToken': token},
    );

    return AssistedRegisterEphemeralKeyResponse.fromMap(
      Map<String, dynamic>.from(result!),
    );
  }

  static Future<void> logout() async {
    await _channel.invokeMethod('logout');
  }

  static Future<Map<String, dynamic>> getUserDetails() async {
    final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'getUserDetails',
    );
    return Map<String, dynamic>.from(result!);
  }

  static Future<void> verify(String code) async {
    await _channel.invokeMethod('verify', {'code': code});
  }

  static Future<Map<String, dynamic>> getLocksBelongingToTile(
    String tileId,
  ) async {
    final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'getLocksBelongingToTile',
      {'tileId': tileId},
    );
    return Map<String, dynamic>.from(result!);
  }

  static Future<void> unlockDevice(String lockId) async {
    await _channel.invokeMethod('unlockDevice', {'lockId': lockId});
  }
}
