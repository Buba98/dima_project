import 'package:dima_project/user/internal_user.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    required this.internalUser,
  });

  final InternalUser internalUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: FutureBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              !snapshot.hasError) {
            return Image.network(
                'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif');
          }
          return Image.asset('/assets/images/no.png');
        },
      ),
    );
  }
}
