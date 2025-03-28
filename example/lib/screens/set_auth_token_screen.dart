import 'package:flutter/material.dart';
import '../utils/api_client.dart';
import '../styles/styles.dart';

class SetAuthTokenScreen extends StatefulWidget {
  const SetAuthTokenScreen({super.key});

  @override
  State<SetAuthTokenScreen> createState() => _SetAuthTokenScreenState();
}

class _SetAuthTokenScreenState extends State<SetAuthTokenScreen> {
  final TextEditingController _tokenController = TextEditingController();
  String? error;
  bool? needsVerification;

  Future<void> _handleSetAuthToken() async {
    setState(() {
      error = null;
      needsVerification = null;
    });

    try {
      final result = await ApiClient.setAuthToken(_tokenController.text);
      setState(() {
        needsVerification = result.requiresVerification;
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
      appBar: AppBar(title: const Text('Set Auth Token')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 20),
              TextField(controller: _tokenController, decoration: inputDecoration('Auth Token')),
              ElevatedButton(onPressed: _handleSetAuthToken, child: const Text('Submit')),
              if (needsVerification != null)
                Text(
                  needsVerification! ? 'Verification required' : 'Verification not required',
                  style: errorTextStyle,
                ),
              if (error != null) Text(error!, style: errorTextStyle),
            ],
          ),
        ),
      ),
    );
  }
}