import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String employeeName;

  HomeScreen({super.key, required this.employeeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Αρχική - Cafe PDA")),
      body: Center(
        child: Text(
          "Καλώς ήρθες, $employeeName!",
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
