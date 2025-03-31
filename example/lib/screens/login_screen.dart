import 'package:doordeck_headless_sdk_flutter/models/assisted_register_ephemeral_key_response.dart';
import 'package:flutter/material.dart';

import '../styles/styles.dart';
import '../utils/api_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? error;

  Future<void> _handleLogin(BuildContext context) async {
    setState(() {
      error = null;
    });
    try {
      final AssistedRegisterEphemeralKeyResponse assistedRegisterEphemeralKeyResponse = await ApiClient.login(
        _emailController.text,
        _passwordController.text,
      );
      if (assistedRegisterEphemeralKeyResponse.requiresVerification) {
        setState(() {
          error = "Requires verification";
        });
      } else {
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 20),
              TextField(
                controller: _emailController,
                decoration: inputDecoration('Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              Container(height: 20),
              TextField(
                controller: _passwordController,
                decoration: inputDecoration('Password'),
                obscureText: true,
              ),
              ElevatedButton(onPressed: () => _handleLogin(context), child: const Text('Submit')),
              if (error != null) Text(error!, style: errorTextStyle),
            ],
          ),
        ),
      ),
    );
  }
}
