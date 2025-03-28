import 'package:doordeck_headless_sdk_flutter_example/screens/home_screen.dart';
import 'package:doordeck_headless_sdk_flutter_example/screens/inspect_tile_screen.dart';
import 'package:doordeck_headless_sdk_flutter_example/screens/login_screen.dart';
import 'package:doordeck_headless_sdk_flutter_example/screens/set_auth_token_screen.dart';
import 'package:doordeck_headless_sdk_flutter_example/screens/unlock_device_screen.dart';
import 'package:doordeck_headless_sdk_flutter_example/screens/user_details_screen.dart';
import 'package:doordeck_headless_sdk_flutter_example/screens/verification_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DoordeckSdkHeadlessExampleApp());
}

class DoordeckSdkHeadlessExampleApp extends StatelessWidget {
  const DoordeckSdkHeadlessExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doordeck Headless SDK',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/set-auth-token': (context) => const SetAuthTokenScreen(),
        '/user-details': (context) => const UserDetailsScreen(),
        '/verification': (context) => const VerificationScreen(),
        '/inspect-tile': (context) => const InspectTileScreen(),
        '/unlock-device': (context) => const UnlockDeviceScreen(),
      },
    );
  }
}
