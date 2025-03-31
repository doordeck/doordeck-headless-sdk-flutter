import 'package:flutter/material.dart';

import '../styles/styles.dart';
import '../utils/api_client.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  Map<String, dynamic>? userDetails;
  String? error;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final result = await ApiClient.getUserDetails();
      setState(() {
        userDetails = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 20),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text(error!, style: errorTextStyle))
                : userDetails != null
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText('User ID: \n${userDetails!['userId'] ?? 'N/A'}'),
                            SelectableText('Email: \n${userDetails!['email']}'),
                            SelectableText('Public Key: \n${userDetails!['publicKey']}'),
                            SelectableText(
                              userDetails!['emailVerified'] ? 'Email Verified' : 'Email Not Verified',
                              style: TextStyle(color: userDetails!['emailVerified'] ? Colors.green : Colors.red),
                            ),
                            if (userDetails!['certificateChainAboutToExpire'] ?? false)
                              const SelectableText('⚠️ Certificate Chain About to Expire', style: errorTextStyle),
                            if (userDetails!['tokenAboutToExpire'] ?? false)
                              const SelectableText('⚠️ Token About to Expire', style: errorTextStyle),
                          ],
                        ),
                      )
                    : const Center(child: Text('No user details available')),
      ),
    );
  }
}
