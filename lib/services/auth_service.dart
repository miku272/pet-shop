import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'helper_function.dart';
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
        final firstName = snapshot.docs[0]['firstName'];
        await HelperFunction.setUserFirstName(firstName);

        final lastName = snapshot.docs[0]['lastName'];
        await HelperFunction.setUserLastName(lastName);

        final email = snapshot.docs[0]['email'];
        await HelperFunction.setUserEmail(email);

        // HelperFunction.setUserFirstName(snapshot.docs[0]['firstName']);
        // HelperFunction.setUserLastName(snapshot.docs[0]['lastName']);
        // HelperFunction.setUserEmail(snapshot.docs[0]['email']);

        // return [
        //   true,
        //   googleUser.displayName!.split(' ')[0],
        //   googleUser.displayName!.split(' ')[1],
        //   googleUser.email,
        // ];
        return true;
      }
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

  Future nameUpdate(String firstName, String lastName) async {
    await DatabaseService().updateName(firstName, lastName);

    await HelperFunction.setUserFirstName(firstName);
    await HelperFunction.setUserLastName(lastName);

    return true;
  }

  Future emailUpdate(String newEmail) async {
    try {
      await firebaseAuth.currentUser!.updateEmail(newEmail);

      await DatabaseService().updateEmail(newEmail);

      await HelperFunction.setUserEmail(newEmail);

      return true;
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future numberUpdate(
      String newPhoneNumber, String verificationId, String smsCode) async {
    try {
      final userPrevNumber = await DatabaseService().getUserNumber();
      if (userPrevNumber == null || userPrevNumber.isEmpty) {
        final credendial = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );

        await firebaseAuth.currentUser!.linkWithCredential(credendial);

        await DatabaseService().updateNumber(newPhoneNumber);

        return true;
      } else {
        final credendial = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );

        await firebaseAuth.currentUser!.updatePhoneNumber(credendial);

        await DatabaseService().updateNumber(newPhoneNumber);

        return true;
      }
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future passwordUpdate(
      String email, String currPassword, String newPassword) async {
    try {
      final cred =
          EmailAuthProvider.credential(email: email, password: currPassword);

      await firebaseAuth.currentUser!.reauthenticateWithCredential(cred);

      await firebaseAuth.currentUser!.updatePassword(newPassword);

      return true;
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future reauthUser(String email, String password) async {
    try {
      final reAuthData =
          EmailAuthProvider.credential(email: email, password: password);

      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(reAuthData);

      return true;
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future signOut() async {
    try {
      await firebaseAuth.signOut();

      await HelperFunction.setUserFirstName('');
      await HelperFunction.setUserLastName('');
      await HelperFunction.setUserEmail('');
    } catch (error) {
      return null;
    }
  }
}
