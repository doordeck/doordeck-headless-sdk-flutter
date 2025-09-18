import 'package:doordeck_headless_sdk_flutter/doordeck_headless_sdk_flutter.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DoordeckHeadlessSdk? _doordeckSdk;
  String? error;
  bool success = false;

  @override
  void initState() {
    super.initState();
    _initializeSdk();
  }

  Future<void> _initializeSdk() async {
    final sdk = await DoordeckHeadlessSdk.initialize(
      authToken: "your_initial_auth_token",
      callback: () async {
        // This function is called when the SDK needs a new token.
        // You should implement your logic to get a new token here.
        // For example, make a network request to your server.
        return 'a_new_refreshed_token';
      },
    );
    setState(() {
      _doordeckSdk = sdk;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _doordeckSdk != null ? _handleUnlockDevice : null,
              child: const Text('Unlock flow'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleUnlockDevice() async {
    setState(() {
      error = null;
      success = false;
    });

    try {
      await _doordeckSdk!.unlockFlow();
      setState(() {
        success = true;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }
}
