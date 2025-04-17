
import 'package:flutter/material.dart';

class OfflineChat extends StatelessWidget {
  const OfflineChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offline"),
      ),
      body: const Center(child: Text("You are offline"),),
    );
  }
}