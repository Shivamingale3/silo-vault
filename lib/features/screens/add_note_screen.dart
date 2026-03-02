import 'package:flutter/material.dart';
import 'package:notes_vault/features/widgets/add_note_view.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addNote() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      // Logic for adding note will go here
      // Use _titleController.text and _descriptionController.text
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Note")),
      body: AddNoteView(
        titleController: _titleController,
        descriptionController: _descriptionController,
        onAddNote: _addNote,
      ),
    );
  }
}
