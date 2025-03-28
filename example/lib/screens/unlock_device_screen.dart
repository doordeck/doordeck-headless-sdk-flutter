import 'package:flutter/material.dart';
import '../utils/api_client.dart';
import '../styles/styles.dart';

class UnlockDeviceScreen extends StatefulWidget {
  const UnlockDeviceScreen({super.key});

  @override
  State<UnlockDeviceScreen> createState() => _UnlockDeviceScreenState();
}

class _UnlockDeviceScreenState extends State<UnlockDeviceScreen> {
  final _lockIdController = TextEditingController();
  String? error;
  bool success = false;

  Future<void> _handleUnlockDevice() async {
    setState(() {
      error = null;
      success = false;
    });

    try {
      await ApiClient.unlockDevice(_lockIdController.text);
      setState(() {
        success = true;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unlock Device')),
      body: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 20),
              TextField(controller: _lockIdController, decoration: inputDecoration('Lock ID')),
              ElevatedButton(onPressed: _handleUnlockDevice, child: const Text('Unlock')),
              if (success) const Text('Device Unlocked!', style: TextStyle(color: Colors.green)),
              if (error != null) Text(error!, style: errorTextStyle),
            ],
          ),
        ),
      ),
    );
  }
}