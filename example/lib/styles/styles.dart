import 'package:flutter/material.dart';

InputDecoration inputDecoration(String label) => InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    );

const TextStyle errorTextStyle = TextStyle(color: Colors.red);
