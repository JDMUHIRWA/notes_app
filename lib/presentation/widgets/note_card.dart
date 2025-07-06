import 'package:flutter/material.dart';
import '../../domain/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      elevation: 2,
      color: const Color.fromARGB(255, 238, 215, 243),
      child: ListTile(
        title: Text(note.text),
        subtitle: Text(note.timestamp.toString()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
