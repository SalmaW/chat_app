import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // _firestore
      //     .collection("Users")
      //     .doc(userCredential.user!.uid)
      //     .set({'uid': userCredential.user!.uid, 'email': email});

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async => await _auth.signOut();

  User? getCurrentUser() => _auth.currentUser;

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await addUsrToFireStore(userCredential.user!);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> sendVerificationLink() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> addUsrToFireStore(User user) async {
    try {
      await _firestore.collection('Users').doc(user.uid).set({
        'email': user.email,
        'uid': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log('Error adding user to Firestore: $e');
    }
  }

  Future<void> deleteCurrentUser(String email, String password) async {
    try {
      User? user = getCurrentUser();

      if (user != null) {
        // Re-authenticate the user to avoid 'requires-recent-login' error
        AuthCredential credential =
            EmailAuthProvider.credential(email: email, password: password);
        await user.reauthenticateWithCredential(credential);

        // Delete user data from Firestore
        await _firestore.collection('Users').doc(user.uid).delete();

        // Delete the user from Firebase Authentication
        await user.delete();
      } else {
        throw Exception("No user is currently signed in.");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        log('User needs to re-authenticate before deletion.');
        throw Exception(
            "Re-authentication required. Please sign in again to delete your account.");
      } else {
        log('Error deleting user: ${e.code}');
        throw Exception(e.code);
      }
    } catch (e) {
      log('Error deleting user: $e');
      throw Exception('An unexpected error occurred.');
    }
  }
}
