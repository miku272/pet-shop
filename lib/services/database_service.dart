import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  final userCollection = FirebaseFirestore.instance.collection('users');

  DatabaseService({this.uid});

  Future addUserData(
    String firstName,
    String lastName,
    String email, {
    String? gender,
    String? profilePic,
  }) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': null,
      'address': null,
      'profilePic': null,
    });
  }

  Future getUserDataUsingEmail(String userEmail) async {
    QuerySnapshot querySnapshot =
        await userCollection.where('email', isEqualTo: userEmail).get(
              const GetOptions(
                source: Source.server,
              ),
            );

    return querySnapshot;
  }
}
