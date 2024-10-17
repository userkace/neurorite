import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



  class FirestoreService {
    User? user = FirebaseAuth.instance.currentUser!;

    final CollectionReference notes =
        FirebaseFirestore.instance.collection('notes');

    Future<void> addNote(String? title, String? content, bool? isPinned){
      return notes.add({
        'title': title,
        'content': content,
        'isPinned': isPinned,
        'email': user!.email,
        'timestamp': Timestamp.now(),
        // 'email':
      });
    }

    Stream<QuerySnapshot> getNotesStream() {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return notes
            .where('email', isEqualTo: user.email) // Filter by current user's email
            .orderBy('timestamp', descending: true)
            .snapshots();
      } else {
        // Handle case where user is not signed in (e.g., return an empty stream)
        return const Stream.empty();
      }
    }

    Future<void> updateNote(String docID, String? title, String? content, bool? isPinned){
      return notes.doc(docID).update({
        'title': title,
        'content': content,
        'isPinned': isPinned,
        'email': user!.email,
        'timestamp': Timestamp.now(),
        // 'email':
      });
    }

    Future<void> deleteNote(String docID) {
      return notes.doc(docID).delete();
    }

    final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

    Future<void> updateUserProfile(String docID, int profile){
      return users.doc(docID).update({
        'profile': profile,
      });
    }

    Future<void> deleteUser(String docID) {
      return users.doc(docID).delete();
    }

}
