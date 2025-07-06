import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/note_model.dart';

class NoteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference getUserNotes(String uid) {
    return _firestore.collection('users').doc(uid).collection('notes');
  }

  Future<List<Note>> fetchNotes(String uid) async {
    final snapshot = await getUserNotes(
      uid,
    ).orderBy('timestamp', descending: true).get();
    return snapshot.docs
        .map((doc) => Note.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>}))
        .toList();
  }

  Future<void> addNote(String uid, String text) async {
    await getUserNotes(
      uid,
    ).add({'text': text, 'timestamp': FieldValue.serverTimestamp()});
  }

  Future<void> updateNote(String uid, String id, String newText) async {
    await getUserNotes(uid).doc(id).update({
      'text': newText,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String uid, String id) async {
    await getUserNotes(uid).doc(id).delete();
  }
}
