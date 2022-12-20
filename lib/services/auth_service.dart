import 'package:firebase_auth/firebase_auth.dart';

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
      return error;
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
