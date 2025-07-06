// Provider class for managing notes state and operations
// This file handles the business logic layer between UI and data repository

// Import Flutter Material package for ChangeNotifier
import 'package:flutter/material.dart';
// Import the Note domain model
import '../domain/note_model.dart';
// Import the repository for data operations
import '../data/note_repository.dart';

/// Provider class that manages notes state and operations
///
/// This class extends ChangeNotifier to provide reactive state management
/// for notes-related data and operations including:
/// - Loading notes from the repository
/// - Adding new notes
/// - Updating existing notes
/// - Deleting notes
/// - Managing loading states and error messages
///
/// Acts as an intermediary between the UI layer and the data repository
class NoteProvider extends ChangeNotifier {
  /// Private instance of the repository for data operations
  final NoteRepository _repo = NoteRepository();

  /// List of all notes for the current user
  List<Note> notes = [];

  /// Loading state indicator for async operations
  bool isLoading = false;

  /// Error message for failed operations, null if no error
  String? errorMessage;

  /// Loads all notes for a specific user from the repository
  ///
  /// [uid] - The unique identifier of the user whose notes to load
  ///
  /// This method:
  /// - Sets loading state to true
  /// - Fetches notes from the repository
  /// - Updates the notes list
  /// - Handles errors and sets error messages
  /// - Notifies listeners of state changes
  Future<void> loadNotes(String uid) async {
    try {
      isLoading = true;
      notifyListeners(); // Notify UI that loading started
      notes = await _repo.fetchNotes(uid);
    } catch (e) {
      errorMessage = 'Failed to load notes';
    } finally {
      isLoading = false;
      notifyListeners(); // Notify UI that loading completed
    }
  }

  /// Adds a new note for the specified user
  ///
  /// [uid] - The unique identifier of the user
  /// [text] - The content of the note to add
  ///
  /// After adding the note, refreshes the notes list to show the new note
  Future<void> addNote(String uid, String text) async {
    try {
      await _repo.addNote(uid, text);
      await loadNotes(uid); // Refresh notes list
    } catch (_) {
      errorMessage = 'Failed to add note';
    }
  }

  /// Updates an existing note's content
  ///
  /// [uid] - The unique identifier of the user
  /// [id] - The unique identifier of the note to update
  /// [newText] - The new content for the note
  ///
  /// After updating the note, refreshes the notes list to show the changes
  Future<void> updateNote(String uid, String id, String newText) async {
    try {
      await _repo.updateNote(uid, id, newText);
      await loadNotes(uid); // Refresh notes list
    } catch (_) {
      errorMessage = 'Failed to update note';
    }
  }

  /// Deletes a note from the user's collection
  ///
  /// [uid] - The unique identifier of the user
  /// [id] - The unique identifier of the note to delete
  ///
  /// After deleting the note, refreshes the notes list to remove the deleted note
  Future<void> deleteNote(String uid, String id) async {
    try {
      await _repo.deleteNote(uid, id);
      await loadNotes(uid); // Refresh notes list
    } catch (_) {
      errorMessage = 'Failed to delete note';
    }
  }
}
