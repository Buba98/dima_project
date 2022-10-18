import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    required this.profilePictureUrl,
  });

  final Future<String> profilePictureUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: FutureBuilder<String>(
        future: profilePictureUrl,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              !snapshot.hasError) {
            return Image.network(snapshot.data!);
          }

          return const Icon(
            Icons.person,
          );
        },
      ),
    );
  }
}
