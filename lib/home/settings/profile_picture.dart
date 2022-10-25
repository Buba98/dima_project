import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    this.modify = false,
    ImageProvider? image,
  }) : image = image ?? const AssetImage('assets/images/profile.png');

  final bool modify;
  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: image,
    );
  }
}
