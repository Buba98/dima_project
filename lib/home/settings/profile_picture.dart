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
    return Stack(
      alignment: Alignment.center,
      children: [
        FittedBox(
          child: CircleAvatar(
            radius: MediaQuery.of(context).size.width,
            backgroundImage: backgroundImage,
          ),
        ),
        if (modify)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    100,
                  ),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Icon(Icons.mode),
              ),
            ),
          ),
      ],
    );
  }
}
