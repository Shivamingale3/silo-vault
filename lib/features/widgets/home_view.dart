import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  final VoidCallback onAddNoteTap;

  const HomeView({super.key, required this.onAddNoteTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes Vault"),
        actions: [
          IconButton(
            color: Colors.black,
            icon: const Icon(Icons.add),
            onPressed: onAddNoteTap,
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: const Center(child: Text("No Notes Found")),
    );
  }
}
