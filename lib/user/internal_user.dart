import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class InternalUser {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  String get uid => _firebaseAuth.currentUser!.uid;

  Reference get _profilePictureRef => _firebaseStorage.ref('$uid/profile.jpeg');

  set uploadProfilePicture(Uint8List image) =>
      _profilePictureRef.putData(image);

  Future<String> get profilePicture => _profilePictureRef.getDownloadURL();
}
