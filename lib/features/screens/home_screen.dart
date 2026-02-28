import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/constants/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes Vault"),
        actions: [
          IconButton(
            color: Colors.black,
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go(AppRoutes.addNote);
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(child: Text("No Notes Found")),
    );
  }
}
