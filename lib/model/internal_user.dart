import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import 'dog.dart';

class InternalUser {
  InternalUser({
    required this.uid,
    required this.name,
    required this.dogs,
  });

  final String name;
  final String uid;
  final List<Dog> dogs;

  Reference get _profilePictureRef =>
      FirebaseStorage.instance.ref('$uid/profile.jpeg');

  set uploadProfilePicture(Uint8List image) =>
      _profilePictureRef.putData(image);

  Future<String> get profilePicture => _profilePictureRef.getDownloadURL();
}
