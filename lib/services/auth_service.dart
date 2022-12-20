import 'package:firebase_auth/firebase_auth.dart';

import './helper_fucntion.dart';
import './database_service.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;

  Future registerUserWithEmailAndPassword(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await DatabaseService(uid: userCredential.user!.uid)
            .addUserData(fullName, email);

        return true;
      }
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future signOut() async {
    try {
      await HelperFunction.setUserName('');
      await HelperFunction.setUserEmail('');

      await firebaseAuth.signOut();
    } catch (error) {
      return null;
    }
  }
}
