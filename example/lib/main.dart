import 'package:doordeck_headless_sdk_flutter_example/screens/home_screen.dart';
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
      },
    );
  }
}
