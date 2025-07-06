// Repository class responsible for handling all database operations related to notes
// This class acts as a data access layer between the UI and Firebase Firestore

// Importing the Firebase Firestore package to interact with the Firestore database
import 'package:cloud_firestore/cloud_firestore.dart';
// Importing the Note model to work with note objects
import '../domain/note_model.dart';

/// Repository class that handles all CRUD operations for notes in Firebase Firestore
///
/// This class provides methods to:
/// - Fetch notes for a specific user
/// - Add new notes
/// - Update existing notes
/// - Delete notes
///
/// All notes are stored in a subcollection under each user's document
class NoteRepository {
  /// Private instance of FirebaseFirestore for database operations
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Returns a reference to the notes collection for a specific user
  ///
  /// [uid] - The unique identifier of the user
  /// Returns: CollectionReference pointing to the user's notes subcollection
  CollectionReference getUserNotes(String uid) {
    return _firestore.collection('users').doc(uid).collection('notes');
  }

  /// Fetches all notes for a specific user from Firestore
  ///
  /// [uid] - The unique identifier of the user whose notes to fetch
  /// Returns: List<Note> containing all notes ordered by timestamp (newest first)
  /// Throws: Exception if the fetch operation fails
  Future<List<Note>> fetchNotes(String uid) async {
    final snapshot = await getUserNotes(
      uid,
    ).orderBy('timestamp', descending: true).get();
    return snapshot.docs
        .map(
          (doc) => Note.fromMap({
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          }),
        )
        .toList();
  }

  /// Adds a new note to the user's notes collection
  ///
  /// [uid] - The unique identifier of the user
  /// [text] - The content/text of the note to be added
  /// Returns: Future<void> that completes when the note is successfully added
  /// Throws: Exception if the add operation fails
  Future<void> addNote(String uid, String text) async {
    await getUserNotes(
      uid,
    ).add({'text': text, 'timestamp': FieldValue.serverTimestamp()});
  }

  /// Updates an existing note's content
  ///
  /// [uid] - The unique identifier of the user
  /// [id] - The unique identifier of the note to update
  /// [newText] - The new content for the note
  /// Returns: Future<void> that completes when the note is successfully updated
  /// Throws: Exception if the update operation fails
  Future<void> updateNote(String uid, String id, String newText) async {
    await getUserNotes(uid).doc(id).update({
      'text': newText,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Deletes a note from the user's notes collection
  ///
  /// [uid] - The unique identifier of the user
  /// [id] - The unique identifier of the note to delete
  /// Returns: Future<void> that completes when the note is successfully deleted
  /// Throws: Exception if the delete operation fails
  Future<void> deleteNote(String uid, String id) async {
    await getUserNotes(uid).doc(id).delete();
  }
}
