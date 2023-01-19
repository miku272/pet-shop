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
      'profilePic': null,
    });
  }

  Future addAddress(
    String fullName,
    String mobNumber,
    String addressLine1,
    String addressLine2,
    String city,
    String state,
  ) async {
    
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

  Future getUserDataUsingUid(String userUid) async {
    QuerySnapshot querySnapshot =
        await userCollection.where('uid', isEqualTo: userUid).get(
              const GetOptions(
                source: Source.server,
              ),
            );

    return querySnapshot;
  }
}
