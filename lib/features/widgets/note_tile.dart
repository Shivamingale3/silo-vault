import 'package:flutter/material.dart';

class NoteTile extends StatefulWidget {
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String noteId;
  const NoteTile({
    super.key,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.noteId,
  });

  @override
  State<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.title),
        subtitle: Text(widget.content),
        trailing: Text(widget.updatedAt.toString()),
      ),
    );
  }
}
