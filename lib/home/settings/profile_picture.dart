import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    required this.profilePictureUrl,
  });

  final Future<String> profilePictureUrl;

  @override
  Widget build(BuildContext context) {
    double size =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height
            ? MediaQuery.of(context).size.height * 1 / 6
            : MediaQuery.of(context).size.width * 1 / 6;

    return CircleAvatar(
      radius: size,
      child: FutureBuilder<String>(
        future: profilePictureUrl,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              !snapshot.hasError) {
            return Image.network(snapshot.data!);
          }

          return Icon(
            Icons.person,
            size: size,
          );
        },
      ),
    );
  }
}
