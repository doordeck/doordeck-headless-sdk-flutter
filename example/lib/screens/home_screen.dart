import 'package:flutter/material.dart';
import '../utils/api_client.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/login'), child: const Text('Login')),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/set-auth-token'), child: const Text('Set Auth Token')),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/user-details'), child: const Text('See User Details')),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/verification'), child: const Text('Verification')),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/inspect-tile'), child: const Text('Inspect Tile')),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/unlock-device'), child: const Text('Unlock Device')),
            ElevatedButton(
              onPressed: () {
                ApiClient.logout().whenComplete(
                  () {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out')));
                    }
                  },
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}