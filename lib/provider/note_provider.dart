import 'package:flutter/material.dart';
import '../domain/note_model.dart';
import '../data/note_repository.dart';

class NoteProvider extends ChangeNotifier {
  final NoteRepository _repo = NoteRepository();

  List<Note> notes = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadNotes(String uid) async {
    try {
      isLoading = true;
      notifyListeners();
      notes = await _repo.fetchNotes(uid);
    } catch (e) {
      errorMessage = 'Failed to load notes';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNote(String uid, String text) async {
    try {
      await _repo.addNote(uid, text);
      await loadNotes(uid);
    } catch (_) {
      errorMessage = 'Failed to add note';
    }
  }

  Future<void> updateNote(String uid, String id, String newText) async {
    try {
      await _repo.updateNote(uid, id, newText);
      await loadNotes(uid);
    } catch (_) {
      errorMessage = 'Failed to update note';
    }
  }

  Future<void> deleteNote(String uid, String id) async {
    try {
      await _repo.deleteNote(uid, id);
      await loadNotes(uid);
    } catch (_) {
      errorMessage = 'Failed to delete note';
    }
  }
}
