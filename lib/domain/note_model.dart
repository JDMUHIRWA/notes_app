import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String text;
  final DateTime timestamp;

  Note({required this.id, required this.text, required this.timestamp});

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'text': text, 'timestamp': timestamp};
  }
}
