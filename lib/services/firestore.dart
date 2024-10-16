import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

  class FirestoreService {

    final CollectionReference notes =
        FirebaseFirestore.instance.collection('notes');

    Future<void> addNote(String? title, String? content, bool? isPinned){
      return notes.add({
        'title': title,
        'content': content,
        'isPinned': isPinned,
        'timestamp': Timestamp.now(),
      });
    }

    Stream<QuerySnapshot> getNotesStream() {
      return notes.orderBy('timestamp', descending: true).snapshots();
    }

    Future<void> updateNote(String docID, String? title, String? content, bool? isPinned){
      return notes.doc(docID).update({
        'title': title,
        'content': content,
        'isPinned': isPinned,
        'timestamp': Timestamp.now(),
      });
    }

    Future<void> deleteNote(String docID) {
      return notes.doc(docID).delete();
    }

    final CollectionReference users =
    FirebaseFirestore.instance.collection('users');

    Future<void> addUser(String? email, String? password,){
        return users.add({
          'email': email,
          'password': password,
        });
    }


}
