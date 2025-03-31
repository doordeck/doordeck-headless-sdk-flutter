import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../styles/styles.dart';
import '../utils/api_client.dart';

class InspectTileScreen extends StatefulWidget {
  const InspectTileScreen({super.key});

  @override
  State<InspectTileScreen> createState() => _InspectTileScreenState();
}

class _InspectTileScreenState extends State<InspectTileScreen> {
  final TextEditingController _tileIdController = TextEditingController();
  List<String>? deviceIds;
  String? error;

  Future<void> _handleInspectTile() async {
    setState(() {
      error = null;
      deviceIds = null;
    });

    try {
      final Map<String, dynamic> result = await ApiClient.getLocksBelongingToTile(_tileIdController.text);
      setState(() {
        deviceIds = List<String>.from(result['deviceIds']);
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
      appBar: AppBar(title: const Text('Inspect Tile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 20),
              TextField(controller: _tileIdController, decoration: inputDecoration('Tile ID')),
              ElevatedButton(onPressed: _handleInspectTile, child: const Text('Inspect')),
              if (deviceIds != null) _buildList(deviceIds!),
              if (error != null) Text(error!, style: errorTextStyle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<String> deviceIds) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
      child: Column(
        children: [
          const Text("DEVICES:"),
          Column(
            children: deviceIds
                .map(
                  (e) => ListTile(
                    title: Text(
                      e,
                      style: const TextStyle(fontSize: 13),
                    ),
                    trailing: const Icon(Icons.copy),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: e));
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
