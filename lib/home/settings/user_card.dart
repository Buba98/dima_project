import 'package:dima_project/home/settings/profile_picture.dart';
import 'package:dima_project/input/show_text.dart';
import 'package:dima_project/model/internal_user.dart';
import 'package:flutter/material.dart';

import '../../input/button.dart';
import 'modify_profile_screen.dart';

class UserCard extends StatelessWidget {
  final InternalUser internalUser;

  const UserCard({
    super.key,
    required this.internalUser,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: FutureBuilder<String>(
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return ProfilePicture(
                backgroundImage:
                    snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData
                        ? NetworkImage(snapshot.data!)
                        : null,
              );
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ShowText(
          title: 'Name:',
          text: internalUser.name!,
        ),
        const SizedBox(
          height: 20,
        ),
        Button(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ModifyProfileScreen(internalUser: internalUser),
            ),
          ),
          text: 'Modify',
        ),
      ],
    );
  }
}
