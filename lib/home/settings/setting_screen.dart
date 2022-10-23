import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/home/settings/dog_card.dart';
import 'package:dima_project/home/settings/user_card.dart';
import 'package:dima_project/input/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../user/user_bloc.dart';
import 'modify_dog_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // InternalUser internalUser =
    //     (context.read<UserBloc>().state as InitializedState).internalUser;

    return BlocBuilder<UserBloc, UserState>(
        builder: (BuildContext context, UserState state) {
      state as InitializedState;
      return Scaffold(
        appBar: const KAppBar(
          text: 'Profile',
        ),
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 12 / 13,
            child: ListView(
              children: [
                UserCard(
                  internalUser: state.internalUser,
                ),
                const Divider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: state.internalUser.dogs!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return DogCard(
                          name: state.internalUser.dogs![index].name!,
                          sex: state.internalUser.dogs![index].sex!,
                        );
                      },
                    ),
                    Button(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ModifyDogScreen(),
                        ),
                      ),
                      text: 'Add new dog',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
