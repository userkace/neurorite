import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:neurorite/utils/error.dart';

final FirestoreService firestoreService = FirestoreService();

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

  Future<void> deleteProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? userEmail = user.email;

        // 1. Delete notes with the user's email
        QuerySnapshot notesSnapshot = await FirebaseFirestore.instance
            .collection('notes')
            .where('email', isEqualTo: userEmail)
            .get();

        for (var doc in notesSnapshot.docs) {
          await doc.reference.delete();
        }

        // 2. Delete the user profile
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          DocumentSnapshot documentSnapshot = userSnapshot.docs.first;
          await documentSnapshot.reference.delete();
          print('Profile and associated notes deleted successfully!');
        } else {
          print('No document found for the current user.');
        }
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error deleting profile and notes: $e');
    }
  }

  Future<void> changeEmail(String newEmail) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.verifyBeforeUpdateEmail(newEmail);
        String oldEmail = user.email!;

        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: oldEmail)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          DocumentSnapshot documentSnapshot = userSnapshot.docs.first;
          String documentId = documentSnapshot.id;

          await FirebaseFirestore.instance
              .collection('users')
              .doc(newEmail)
              .set(documentSnapshot.data() as Map<String, dynamic>);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(newEmail)
              .update({'email': newEmail, 'profile': 0});

          await FirebaseFirestore.instance
              .collection('users')
              .doc(documentId)
              .delete();

          QuerySnapshot notesSnapshot = await FirebaseFirestore.instance
              .collection('notes')
              .where('email', isEqualTo: oldEmail)
              .get();

          for (var doc in notesSnapshot.docs) {
            await doc.reference.update({'email': newEmail});
          }

          await FirebaseAuth.instance.signOut();
        } else {
          const ErrorDialog(title: 'Error', content: 'No user document found for the current user in Firestore.');
        }
      } else {
        const ErrorDialog(title: 'Error', content: 'No user currently signed in.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ErrorDialog(title: 'Error', content: 'Error with changing email: ${e.code}');
      } else {
        ErrorDialog(title: 'Error', content: 'Error with changing email: ${e.code}');
      }
    }
  }


  // Future<void> changeEmail(String newEmail) async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       await user.verifyBeforeUpdateEmail(newEmail);
  //       String oldEmail = user.email!;
  //
  //       QuerySnapshot userSnapshot = await FirebaseFirestore.instance
  //           .collection('users')
  //           .where('email', isEqualTo: oldEmail)
  //           .get();
  //
  //       if (userSnapshot.docs.isNotEmpty) {
  //         DocumentSnapshot documentSnapshot = userSnapshot.docs.first;
  //         await documentSnapshot.reference.update({'email': newEmail});
  //         await documentSnapshot.reference.update({'profile': 0});
  //       } else {
  //         const ErrorDialog(title: 'Error', content: 'No user document found for the current user in Firestore.');
  //       }
  //
  //       QuerySnapshot notesSnapshot = await FirebaseFirestore.instance
  //           .collection('notes')
  //           .where('email', isEqualTo: oldEmail)
  //           .get();
  //
  //       for (var doc in notesSnapshot.docs) {
  //         await doc.reference.update({'email': newEmail});
  //       }
  //       await FirebaseAuth.instance.signOut();
  //     } else {
  //       const ErrorDialog(title: 'Error', content: 'No user currently signed in.');
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'requires-recent-login') {
  //       ErrorDialog(title: 'Error', content: 'Error with changing email: ${e.code}');
  //     } else {
  //       ErrorDialog(title: 'Error', content: 'Error with changing email: ${e.code}');
  //     }
  //   }
  // }

  Future<void> changePassword(String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        await FirebaseAuth.instance.signOut();
      } else {
        const ErrorDialog(title: 'Error', content: 'No user currently signed in.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ErrorDialog(title: 'Error', content: 'Error with changing password: ${e.code}');
      } else {
        ErrorDialog(title: 'Error', content: 'Error with changing password: ${e.code}');
      }
    }
  }
}
