import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final petFolder = FirebaseStorage.instance.ref().child('pets');

  Future<String> uploadPetImages(
    String petId,
    File image,
    String fileName,
  ) async {
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    final uniqueFolder = petFolder.child(petId);
    final ref = uniqueFolder.child(fileName);
    final uploadTask = ref.putFile(image, metadata);
    String imageUrl = '';

    final taskSnapshot = await uploadTask.whenComplete(() => null);

    imageUrl = await taskSnapshot.ref.getDownloadURL();

    return imageUrl;
  }

  Future removePetImages(String petId) async {
    await FirebaseStorage.instance.ref('pets/$petId').listAll().then((value) {
      for (var element in value.items) {
        FirebaseStorage.instance.ref(element.fullPath).delete();
      }
    });
  }
}
