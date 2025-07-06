// Notes screen widget for displaying and managing user notes
// This file contains the main notes interface with CRUD operations

// Import Flutter Material package for UI components
import 'package:flutter/material.dart';
// Import Provider package for state management
import 'package:provider/provider.dart';
// Import providers for notes and authentication state
import '../../provider/note_provider.dart';
import '../../provider/auth_provider.dart';
// Import domain model and custom widgets
import '../../domain/note_model.dart';
import '../widgets/note_card.dart';

/// Notes screen widget that displays the main notes interface
///
/// This widget provides:
/// - A list of all user's notes
/// - Add new note functionality
/// - Edit existing notes
/// - Delete notes with confirmation
/// - Logout functionality
/// - Loading states and empty state handling
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

/// State class for NotesScreen widget
///
/// Manages:
/// - Loading notes on screen initialization
/// - Dialogs for adding and editing notes
/// - Note deletion confirmation
/// - UI state based on loading and data availability
class _NotesScreenState extends State<NotesScreen> {
  /// Initialize the screen and load user's notes
  ///
  /// This method runs after the widget is inserted into the tree
  /// and loads the current user's notes from the database
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // Ensure widget is still in tree
      final user = Provider.of<AuthProvider>(context, listen: false).user!;
      Provider.of<NoteProvider>(context, listen: false).loadNotes(user.uid);
    });
  }

  /// Shows a dialog for adding a new note
  ///
  /// This method:
  /// - Creates a text field for note input
  /// - Provides cancel and add buttons
  /// - Adds the note to the database when confirmed
  /// - Closes the dialog after successful addition
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
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          // Add button
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
              if (!mounted) return; // Ensure widget is still in tree
              Navigator.pop(context); // Close dialog
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog for editing an existing note
  ///
  /// [note] - The note object to be edited
  ///
  /// This method:
  /// - Pre-fills the text field with existing note content
  /// - Provides cancel and save buttons
  /// - Updates the note in the database when confirmed
  /// - Closes the dialog after successful update
  void _showEditNoteDialog(Note note) {
    final controller = TextEditingController(text: note.text);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Note'),
        content: TextField(controller: controller),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          // Save button
          ElevatedButton(
            onPressed: () async {
              final user = Provider.of<AuthProvider>(
                context,
                listen: false,
              ).user!;
              // Note: Fixed bug - now correctly calls updateNote instead of addNote
              await Provider.of<NoteProvider>(
                context,
                listen: false,
              ).updateNote(user.uid, note.id, controller.text.trim());
              if (!mounted) return; // Ensure widget is still in tree
              Navigator.pop(context); // Close dialog
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  /// Builds the main notes screen UI
  ///
  /// Creates a screen with:
  /// - App bar with title and logout button
  /// - Loading indicator when fetching notes
  /// - Empty state message when no notes exist
  /// - List of notes when notes are available
  /// - Floating action button for adding new notes
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          // Logout button in app bar
          IconButton(
            onPressed: () => auth.logout(),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: noteProvider.isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading state
          : noteProvider.notes.isEmpty
          ? const Center(
              child: Text('Nothing here yet—tap ➕ to add a note.'),
            ) // Empty state
          : ListView.builder(
              // Notes list
              itemCount: noteProvider.notes.length,
              itemBuilder: (context, index) {
                final note = noteProvider.notes[index];
                return NoteCard(
                  note: note,
                  onEdit: () => _showEditNoteDialog(note), // Edit callback
                  onDelete: () => _confirmDelete(note), // Delete callback
                );
              },
            ),
      // Floating action button for adding new notes
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Shows a confirmation dialog before deleting a note
  ///
  /// [note] - The note object to be deleted
  ///
  /// This method:
  /// - Shows a confirmation dialog to prevent accidental deletion
  /// - Provides cancel and delete buttons
  /// - Deletes the note from the database when confirmed
  /// - Closes the dialog after successful deletion
  void _confirmDelete(Note note) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          // Delete button
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
              if (!mounted) return; // Ensure widget is still in tree
              Navigator.pop(context); // Close dialog
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
