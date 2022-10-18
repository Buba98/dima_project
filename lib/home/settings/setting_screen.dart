import 'package:dima_project/custom_widgets/button.dart';
import 'package:dima_project/home/settings/dog_card.dart';
import 'package:dima_project/home/settings/user_card.dart';
import 'package:dima_project/model/internal_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../user/user_bloc.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    InternalUser internalUser =
        (context.read<UserBloc>().state as InitializedState).internalUser;

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 12 / 13,
        child: Column(
          children: [
            UserCard(
              name: internalUser.name!,
              userProfileUrl: internalUser.profilePicture,
            ),
            const Divider(),
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: internalUser.dogs!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return DogCard(
                        name: internalUser.dogs![index].name!,
                        sex: internalUser.dogs![index].sex!,
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Button(
                      onPressed: () => null,
                      text: 'Add new dog',
                    ),
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
