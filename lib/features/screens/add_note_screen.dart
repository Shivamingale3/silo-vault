import 'package:flutter/material.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> addNote() async {
      final messenger = ScaffoldMessenger.of(context);
      try {} catch (e) {
        messenger.showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Add Note")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 20,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Title",
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Description",
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Add Note"),
            ),
          ),
        ],
      ),
    );
  }
}
