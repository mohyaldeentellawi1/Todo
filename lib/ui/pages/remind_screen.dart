import 'package:flutter/material.dart';

class RemindScreen extends StatelessWidget {
  const RemindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remind Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the second screen using a named route.
          },
          child: const Text('Launch screen'),
        ),
      ),
    );
  }
}
