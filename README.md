# doordeck_headless_sdk_flutter

## Overview
The `doordeck_headless_sdk_flutter` is a lightweight Flutter SDK built on top of the [Doordeck Headless SDK](https://github.com/doordeck/doordeck-headless-sdk). This SDK provides a minimal interface for authentication and lock management, focusing on user-facing operations. It enables Flutter applications to authenticate users, manage authentication tokens, retrieve lock details, and unlock devices via Doordeck's platform.

## Installation

Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  doordeck_headless_sdk_flutter: ${LATEST_VERSION}
```

Then run:

```bash
flutter pub get
```

## Usage

### Import the package

```dart
import 'package:doordeck_headless_sdk_flutter/doordeck_headless_sdk_flutter.dart';
```

## Authentication Methods

#### `login(String email, String password)`
Logs the user in with their email and password.

> **Note:** If login is performed without verification within the same session, authentication will only persist in runtime memory and will be lost when the app restarts.

```dart
await DoordeckFlutter.login("user@example.com", "password123");
```

---

#### `setAuthToken(String authToken)`
Sets an authentication token manually.

> **Note:** Like login, authentication without verification will only persist in runtime memory and will be lost after the app restarts.

```dart
await DoordeckFlutter.setAuthToken("your-auth-token");
```

---

#### `verify(String code)`
Verifies an ephemeral key registration with a verification code. Upon successful verification, the user ID and authentication context are saved in persistent storage.

```dart
await DoordeckFlutter.verify("123456");
```

---

#### `logout()`
Logs out the current user and clears the stored authentication context, including removing the persistent user ID.

```dart
await DoordeckFlutter.logout();
```

## Device and Tile Operations

#### `getLocksBelongingToTile(String tileId)`
Retrieves a list of locks associated with a specific tile.

```dart
final locks = await DoordeckFlutter.getLocksBelongingToTile("tile-uuid");
print(locks);
```

---

#### `unlockDevice(String lockId)`
Unlocks a device given its lock ID.

```dart
await DoordeckFlutter.unlockDevice("lock-uuid");
```

## Error Handling
Each method returns a `Future`. If an error occurs, it will throw a `PlatformException` containing a code and message.

## License
This SDK follows the Doordeck licensing agreement. Ensure compliance with Doordeck's API usage policies before integrating this SDK into your project.

## Support
For additional support, refer to the [Doordeck Developer Documentation](https://developer.doordeck.com/docs/#introduction).
