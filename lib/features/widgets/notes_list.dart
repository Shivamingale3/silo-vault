import 'package:flutter/material.dart';
import 'package:notes_vault/database/models/user_note.dart';
import 'package:notes_vault/features/widgets/note_tile.dart';

class NotesList extends StatefulWidget {
  final List<UserNote> notes;
  const NotesList({super.key, required this.notes});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return NoteTile(
          noteId: widget.notes[index].noteId.toString(),
          title: widget.notes[index].title,
          content: widget.notes[index].content,
          createdAt: widget.notes[index].createdAt,
          updatedAt: widget.notes[index].updatedAt,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 16);
      },
      itemCount: widget.notes.length,
    );
  }
}
