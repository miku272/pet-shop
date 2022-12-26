import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './helper_fucntion.dart';
import './database_service.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;

  Future registerUserWithEmailAndPassword(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await DatabaseService(uid: userCredential.user!.uid)
            .addUserData(firstName, lastName, email);

        return true;
      }
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future loginUserWithEmailAndPassword(String email, String password) async {
    try {
      final usercredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (usercredential.user != null) {
        return true;
      }
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future loginUserWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        QuerySnapshot snapshot =
            await DatabaseService().getUserDataUsingEmail(googleUser.email);

        if (snapshot.docs.isEmpty) {
          await DatabaseService(uid: firebaseAuth.currentUser!.uid).addUserData(
            googleUser.displayName!.split(' ')[0],
            googleUser.displayName!.split(' ')[1],
            googleUser.email,
            profilePic: googleUser.photoUrl,
          );
        }
      }

      return [
        true,
        googleUser.displayName!.split(' ')[0],
        googleUser.displayName!.split(' ')[1],
        googleUser.email,
      ];
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future resetEmailPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);

      return true;
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future sendVerificationEmail() async {
    try {
      await firebaseAuth.currentUser!.sendEmailVerification();

      return true;
    } catch (error) {
      return error.toString();
    }
  }

  Future passwordUpdate(String newPassword) async {
    try {
      await firebaseAuth.currentUser!.updatePassword(newPassword);

      return true;
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future signOut() async {
    try {
      await HelperFunction.setUserFirstName('');
      await HelperFunction.setUserLastName('');
      await HelperFunction.setUserEmail('');

      await firebaseAuth.signOut();
    } catch (error) {
      return null;
    }
  }
}
