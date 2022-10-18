import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import 'dog.dart';

class InternalUser {
  InternalUser({
    required this.uid,
    this.name,
    required this.dogs,
    required this.fetched,
  });

  final String? name;
  final List<Dog>? dogs;
  final String uid;
  bool fetched;

  Reference get _profilePictureRef =>
      FirebaseStorage.instance.ref('$uid/profile.jpeg');

  set uploadProfilePicture(Uint8List image) =>
      _profilePictureRef.putData(image);

  Future<String> get profilePicture => _profilePictureRef.getDownloadURL();
}
