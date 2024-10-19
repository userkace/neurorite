import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  User? user = FirebaseAuth.instance.currentUser!;

  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  Future<void> addNote(String? title, String? content, bool? isPinned) {
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
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return notes
          .where('email',
              isEqualTo: user!.email) // Filter by current user's email
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      // Handle case where user is not signed in (e.g., return an empty stream)
      return const Stream.empty();
    }
  }

  Future<void> updateNote(
      String docID, String? title, String? content, bool? isPinned) {
    return notes.doc(docID).update({
      'title': title,
      'content': content,
      'isPinned': isPinned,
      'email': user!.email,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateProfile(int newProfileValue) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get the current user's email
        String? userEmail = user.email;
        // Query the "store" collection to find the document with the matching email
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .get();
        // Update the profile value if a document is found
        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
          await documentSnapshot.reference.update({'profile': newProfileValue});
          print('Profile updated successfully!');
        } else {
          print('No document found for the current user.');
        }
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  Future<void> deleteUser(String docID) {
    return users.doc(docID).delete();
  }
}
