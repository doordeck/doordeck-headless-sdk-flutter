import 'package:flutter/material.dart';

import '../styles/styles.dart';
import '../utils/api_client.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _codeController = TextEditingController();
  String? error;
  bool success = false;

  Future<void> _handleVerification() async {
    setState(() {
      error = null;
      success = false;
    });

    try {
      await ApiClient.verify(_codeController.text);
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
      appBar: AppBar(title: const Text('Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 20),
              TextField(
                controller: _codeController,
                decoration: inputDecoration('Verification Code'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(onPressed: _handleVerification, child: const Text('Submit')),
              if (success) const Text('Verification successful!', style: TextStyle(color: Colors.green)),
              if (error != null) Text(error!, style: errorTextStyle),
            ],
          ),
        ),
      ),
    );
  }
}
