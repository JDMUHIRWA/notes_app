// Custom widget for displaying individual note cards
// This file contains the NoteCard widget used in the notes list

// Import Flutter Material package for UI components
import 'package:flutter/material.dart';
// Import the Note domain model
import '../../domain/note_model.dart';

/// A custom widget that displays a single note in a card format
///
/// This widget provides:
/// - Visual representation of a note with content and timestamp
/// - Edit and delete action buttons
/// - Styled card layout with custom colors
/// - Callback functions for edit and delete operations
class NoteCard extends StatelessWidget {
  /// The note object to display
  final Note note;

  /// Callback function triggered when edit button is pressed
  final VoidCallback onEdit;

  /// Callback function triggered when delete button is pressed
  final VoidCallback onDelete;

  /// Constructor for NoteCard widget
  ///
  /// [note] - The note object to display
  /// [onEdit] - Callback function for edit action
  /// [onDelete] - Callback function for delete action
  const NoteCard({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  /// Builds the note card UI
  ///
  /// Creates a card with:
  /// - Note content as title
  /// - Timestamp as subtitle
  /// - Edit and delete action buttons
  /// - Custom styling and colors
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 20,
      ), // Card spacing
      elevation: 2, // Shadow depth
      color: const Color.fromARGB(255, 238, 215, 243), // Custom card color
      child: ListTile(
        title: Text(note.text), // Note content
        subtitle: Text(note.timestamp.toString()), // Note timestamp
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Delete button with red color
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
            // Edit button with blue color
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
