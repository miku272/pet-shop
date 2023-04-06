import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './storage_service.dart';

class DatabaseService {
  final String? uid;
  final userCollection = FirebaseFirestore.instance.collection('users');
  final chatCollection = FirebaseFirestore.instance.collection('chats');
  final petCollection = FirebaseFirestore.instance.collection('pets');
  final productCollection = FirebaseFirestore.instance.collection('products');
  final ordersCollection = FirebaseFirestore.instance.collection('orders');

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
      'defaultAddressId': '',
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'chats': [],
      'number': null,
      'avatar': 'm',
      'profilePic': null,
    });
  }

  Future updateAvatar(String avatar) async {
    return await userCollection.doc(FirebaseAuth.instance.currentUser!.uid).set(
      {'avatar': avatar},
      SetOptions(merge: true),
    );
  }

  Future getAvatar() async {
    final userData =
        await userCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();

    return userData.data()!['avatar'];
  }

  Future updateName(String firstName, String lastName) async {
    return await userCollection.doc(FirebaseAuth.instance.currentUser!.uid).set(
      {
        'firstName': firstName,
        'lastName': lastName,
      },
      SetOptions(merge: true),
    );
  }

  Future updateEmail(String newEmail) async {
    return await userCollection.doc(FirebaseAuth.instance.currentUser!.uid).set(
      {
        'email': newEmail,
      },
      SetOptions(merge: true),
    );
  }

  Future updateNumber(String newPhoneNumber) async {
    return await userCollection.doc(FirebaseAuth.instance.currentUser!.uid).set(
      {
        'number': newPhoneNumber,
      },
      SetOptions(merge: true),
    );
  }

  Future getUserNumber() async {
    final userData =
        await userCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();

    return userData.data()!['number'];
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

  Future updateAddress(
    String addressId,
    String fullName,
    String mobNumber,
    String pinCode,
    String addressLine1,
    String addressLine2,
    String city,
    String state,
  ) async {
    return await userCollection
        .doc(uid)
        .collection('address')
        .doc(addressId)
        .set(
      {
        'fullName': fullName,
        'mobNumber': mobNumber,
        'pinCode': pinCode,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'city': city,
        'state': state,
      },
      SetOptions(merge: true),
    );
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

  Future<void> setDefaultAddress(String addressId) async {
    await userCollection.doc(FirebaseAuth.instance.currentUser!.uid).set(
      {'defaultAddressId': addressId},
      SetOptions(merge: true),
    );
  }

  Future<String> getDefaultAddress() async {
    final userData =
        await userCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();

    return userData.data()!['defaultAddressId'];
  }

  Future<DocumentSnapshot> getAddressUsingUid(
      String userId, String addressId) async {
    DocumentSnapshot addressData = await userCollection
        .doc(userId)
        .collection('address')
        .doc(addressId)
        .get();

    return addressData;
  }

  Future deleteUserAddress(String docId) async {
    String defaultAddressId = await getDefaultAddress();

    if (defaultAddressId == docId) {
      await setDefaultAddress('');
    }

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

    // print(querySnapshot.docs[0].data());
    return querySnapshot;
    // Call using 'querySnapshot.docs[0].data()';
  }

  Future<bool> addItemToWishlist(String userId, String productId) async {
    await userCollection.doc(userId).update({
      'wishlist': FieldValue.arrayUnion([productId]),
    });

    return true;
  }

  Future<bool> removeItemFromWishlist(String userId, String productId) async {
    await userCollection.doc(userId).update({
      'wishlist': FieldValue.arrayRemove([productId])
    });

    return true;
  }

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getUserChats() async {
    return userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  Future<String> createChat(String senderId, String receiverId) async {
    final chatDoc = await chatCollection.add({
      'senderId': senderId,
      'senderName': null,
      'receiverId': receiverId,
      'receiverName': null,
      'chatId': null,
      'recentMessage': null,
      'recentMessageSender': null,
      'recentMessageTime': null,
    });

    final senderData = await getUserDataUsingUid(senderId);
    final receiverData = await getUserDataUsingUid(receiverId);

    await chatDoc.update({
      'chatId': chatDoc.id,
      'senderName':
          '${senderData.docs[0]['firstName']} ${senderData.docs[0]['lastName']}',
      'receiverName':
          '${receiverData.docs[0]['firstName']} ${receiverData.docs[0]['lastName']}',
    });

    final senderDocRef = userCollection.doc(senderId);
    final receiverDocRef = userCollection.doc(receiverId);

    await senderDocRef.update(
      {
        'chats': FieldValue.arrayUnion([(chatDoc.id)]),
      },
    );

    await receiverDocRef.update(
      {
        'chats': FieldValue.arrayUnion([(chatDoc.id)]),
      },
    );

    return chatDoc.id;
  }

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getChatDataUsingUid(
      String chatId) async {
    return chatCollection.doc(chatId).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getStaticChatDataUsingUid(
      String chatId) async {
    final chatData = await chatCollection.doc(chatId).get();

    return chatData;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChats(String chatId) {
    return chatCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  Future sendMessage(String chatId, Map<String, dynamic> chat) async {
    await chatCollection.doc(chatId).collection('messages').add(chat);

    await chatCollection.doc(chatId).update({
      'recentMessage': chat['message'],
      'recentMessageSender': chat['senderId'],
      'recentMessageTime': chat['time'].toString(),
    });
  }

  Future addPet(
    String authorId,
    String datePosted,
    List<File> imageList,
    String type,
    bool avlForAdopt,
    String name,
    String breed,
    int age,
    String color,
    int weight,
    String location,
    String description,
  ) async {
    String imageLink;
    List<String> imageLinkList = [];
    var index = 0;

    final petDoc = await petCollection.add({
      'uid': null,
      'authorId': authorId,
      'datePosted': datePosted,
      'imageList': null,
      'petType': type,
      'avlForAdopt': avlForAdopt,
      'petName': name,
      'petBreed': breed,
      'petAge': age,
      'petColor': color,
      'petWeight': weight,
      'location': location,
      'likedBy': [],
      'description': description,
    });

    for (File element in imageList) {
      imageLink = await StorageService().uploadPetImages(
        petDoc.id,
        element,
        index.toString(),
      );

      imageLinkList.add(imageLink);
      index++;
    }

    petDoc.update({
      'uid': petDoc.id,
      'imageList': FieldValue.arrayUnion(imageLinkList),
    });
  }

  Future<Object?> getPetDataUsinguid(String petId) async {
    DocumentSnapshot petData = await petCollection.doc(petId).get();

    return petData.data();
  }

  Future<QuerySnapshot> getPetDataUsingAuthorId(String authorId) async {
    QuerySnapshot petData =
        await petCollection.where('authorId', isEqualTo: authorId).get(
              const GetOptions(
                source: Source.server,
              ),
            );

    return petData;
  }

  Future updatePet(
    String petId,
    bool avlForAdopt,
    String name,
    String breed,
    int age,
    String color,
    int weight,
    String location,
    String description,
  ) async {
    return await petCollection.doc(petId).update({
      'avlForAdopt': avlForAdopt,
      'petName': name,
      'petBreed': breed,
      'petAge': age,
      'petColor': color,
      'petWeight': weight,
      'location': location,
      'description': description,
    });
  }

  Future deletePetDataUsingUid(String uid) async {
    StorageService().removePetImages(uid);

    await petCollection.doc(uid).delete();
  }

  Future<QuerySnapshot> getDogPetDataForHomeScreen() async {
    QuerySnapshot querySnapshot =
        await petCollection.where('petType', isEqualTo: 'dog').limit(5).get(
              const GetOptions(
                source: Source.server,
              ),
            );

    return querySnapshot;
  }

  Future<QuerySnapshot> getCatPetDataForHomeScreen() async {
    QuerySnapshot querySnapshot =
        await petCollection.where('petType', isEqualTo: 'cat').limit(5).get(
              const GetOptions(
                source: Source.server,
              ),
            );

    return querySnapshot;
  }

  Future likePost(String petId, String likedById) async {
    return await petCollection.doc(petId).update({
      'likedBy': FieldValue.arrayUnion([likedById]),
    });
  }

  Future removeLike(String petId, String unlikeById) async {
    return await petCollection.doc(petId).update({
      'likedBy': FieldValue.arrayRemove([unlikeById]),
    });
  }

  Future<QuerySnapshot> getAllProducts() async {
    QuerySnapshot productData = await productCollection.get();

    return productData;
  }

  Future<DocumentSnapshot> getProductDataUsingUid(String uid) async {
    DocumentSnapshot productData = await productCollection.doc(uid).get();

    return productData;
  }

  Future increaseProductStock(String productId, int quantity) async {
    final product = await productCollection.doc(productId).get();
    Map productData = product.data() as Map;
    int productStock = productData['stock'];

    await productCollection.doc(productId).update({
      'stock': productStock + quantity,
    });
  }

  Future decreaseProductStock(String productId, int quantity) async {
    final product = await productCollection.doc(productId).get();
    Map productData = product.data() as Map;
    int productStock = productData['stock'];

    await productCollection.doc(productId).update({
      'stock': productStock - quantity,
    });
  }

  Future<QuerySnapshot> getDogProducts() async {
    QuerySnapshot productData = await productCollection
        .where(
          'category',
          isEqualTo: 'dog',
        )
        .get();

    return productData;
  }

  Future<QuerySnapshot> getCatProducts() async {
    QuerySnapshot productData = await productCollection
        .where(
          'category',
          isEqualTo: 'cat',
        )
        .get();

    return productData;
  }

  Future<String> addToCart(String userId, String productId) async {
    QuerySnapshot cartData =
        await userCollection.doc(userId).collection('cart').get();

    for (var element in cartData.docs) {
      final cart = element.data() as Map;

      if (cart['productId'] == productId) {
        return 'Item already in the cart';
      }
    }

    await userCollection.doc(userId).collection('cart').add({
      'productId': productId,
      'quantity': 1,
    });

    return 'Item added to cart';
  }

  Future removeFromCart(String userId, String cartId) async {
    await userCollection.doc(userId).collection('cart').doc(cartId).delete();
  }

  Future clearCart(String userId) async {
    QuerySnapshot cart =
        await userCollection.doc(userId).collection('cart').get();

    for (var element in cart.docs) {
      await element.reference.delete();
    }
  }

  Future<bool> updateCartProductQuantity(
      String userId, String cartId, int qty) async {
    if (qty < 1) {
      return false;
    } else if (qty > 5) {
      return false;
    }

    await userCollection.doc(userId).collection('cart').doc(cartId).update(
      {
        'quantity': qty,
      },
    );

    return true;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserCartData(String userId) {
    Stream<QuerySnapshot<Map<String, dynamic>>> cartSize =
        userCollection.doc(userId).collection('cart').snapshots();

    return cartSize;
  }

  Future<QuerySnapshot> getUserStaticCartData(String userId) async {
    QuerySnapshot cartData =
        await userCollection.doc(userId).collection('cart').get();

    return cartData;
  }

  Future addOrder(
    String orderedById,
    String? paymentId,
    String? orderId,
    String productId,
    int totalAmount,
    int quantity,
    bool isOrderDelivered,
    bool isOrderCancelled,
    String orderDate,
    String paymentMethod,
    String fullName,
    String addressLine1,
    String addressLine2,
    String city,
    String state,
    String pinCode,
    String mobNumber,
  ) async {
    DocumentReference orderDoc = await ordersCollection.add({
      'uid': null,
      'orderedById': orderedById,
      'paymentId': paymentId,
      'orderId': orderId,
      'productId': productId,
      'totalAmount': totalAmount / 100,
      'quantity': quantity,
      'isOrderDelivered': isOrderDelivered,
      'isOrderCancelled': isOrderCancelled,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'fullName': fullName,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'pinCode': pinCode,
      'mobNumber': mobNumber,
    });

    await orderDoc.update({
      'uid': orderDoc.id,
    });
  }

  Future cancelOrder(String orderUid) async {
    await ordersCollection.doc(orderUid).update({
      'isOrderCancelled': true,
    });
  }

  Future<QuerySnapshot> getUserOrders(String userId) async {
    QuerySnapshot userOrders =
        await ordersCollection.where('orderedById', isEqualTo: userId).get();

    return userOrders;
  }
}
