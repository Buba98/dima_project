import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    this.modify = false,
    ImageProvider? image,
    required this.radius,
  }) : image = image ?? const AssetImage('assets/images/profile.png');

  final bool modify;
  final ImageProvider image;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 0,
            minWidth: 0,
            maxHeight: radius * 2,
            maxWidth: radius * 2,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: radius,
                child: ClipOval(
                  child: Image(
                    fit: BoxFit.fill,
                    width: radius * 2,
                    height: radius * 2,
                    image: image,
                  ),
                ),
              ),
              if (modify)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: radius / 2,
                    height: radius / 2,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: Icon(
                      Icons.mode,
                      size: radius / 4,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
