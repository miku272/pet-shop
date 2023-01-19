import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    String pinCode,
    String addressLine1,
    String addressLine2,
    String city,
    String state,
  ) async {
    return await userCollection.doc(uid).collection('address').doc().set({
      'fullName': fullName,
      'mobNumber': mobNumber,
      'pinCode': pinCode,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
    });
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAddress() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> userAddresses = [];

    final address = await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('address')
        .get();

    for (var element in address.docs) {
      userAddresses.add(element);
    }

    return userAddresses;
  }

  Future deleteUserAddress(String docId) async {
    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('address')
        .doc(docId)
        .delete();
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
