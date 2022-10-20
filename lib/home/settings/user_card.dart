import 'package:dima_project/home/settings/modify_profile_screen.dart';
import 'package:dima_project/home/settings/profile_picture.dart';
import 'package:dima_project/model/internal_user.dart';
import 'package:flutter/material.dart';

import '../../input/button.dart';

class UserCard extends StatelessWidget {
  final InternalUser internalUser;

  const UserCard({
    super.key,
    required this.internalUser,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 10,
              child: FutureBuilder<String>(
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
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
            const Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Name:'),
                  Text(
                    internalUser.name!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
