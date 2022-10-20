import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    this.modify = false,
    ImageProvider? backgroundImage,
  }) : backgroundImage =
            backgroundImage ?? const AssetImage('assets/images/profile.png');

  final bool modify;
  final ImageProvider backgroundImage;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: CircleAvatar(
        backgroundImage: backgroundImage,
      ),
    );
  }
}
