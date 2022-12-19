import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  final userCollection = FirebaseFirestore.instance.collection('users');

  DatabaseService({this.uid});

  Future addUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'gender': null,
      'address': null,
      'profilePic': null,
    });
  }
}
