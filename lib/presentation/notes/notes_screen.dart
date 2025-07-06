import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/note_provider.dart';
import '../../provider/auth_provider.dart';
import '../../domain/note_model.dart';
import '../widgets/note_card.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final user = Provider.of<AuthProvider>(context, listen: false).user!;
      Provider.of<NoteProvider>(context, listen: false).loadNotes(user.uid);
    });
  }

  void _showAddNoteDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Note'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter note...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = Provider.of<AuthProvider>(
                context,
                listen: false,
              ).user!;
              await Provider.of<NoteProvider>(
                context,
                listen: false,
              ).addNote(user.uid, controller.text.trim());
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditNoteDialog(Note note) {
    final controller = TextEditingController(text: note.text);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Note'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = Provider.of<AuthProvider>(
                context,
                listen: false,
              ).user!;
              await Provider.of<NoteProvider>(
                context,
                listen: false,
              ).addNote(user.uid, controller.text.trim());
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            onPressed: () => auth.logout(),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: noteProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : noteProvider.notes.isEmpty
          ? const Center(child: Text('Nothing here yet—tap ➕ to add a note.'))
          : ListView.builder(
              itemCount: noteProvider.notes.length,
              itemBuilder: (context, index) {
                final note = noteProvider.notes[index];
                return NoteCard(
                  note: note,
                  onEdit: () => _showEditNoteDialog(note),
                  onDelete: () => _confirmDelete(note),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(Note note) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = Provider.of<AuthProvider>(
                context,
                listen: false,
              ).user!;
              await Provider.of<NoteProvider>(
                context,
                listen: false,
              ).deleteNote(user.uid, note.id);
              if (!mounted) return;
              Navigator.pop(context);
            },

            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
