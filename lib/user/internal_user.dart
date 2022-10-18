import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class InternalUser {
  InternalUser({
    required this.uid,
    required this.name,
  });

  final String name;
  final String uid;

  Reference get _profilePictureRef => FirebaseStorage.instance.ref('$uid/profile.jpeg');

  set uploadProfilePicture(Uint8List image) =>
      _profilePictureRef.putData(image);

  Future<String> get profilePicture => _profilePictureRef.getDownloadURL();
}