import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/home/settings/user_card.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/show_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/dog.dart';
import '../../user/user_bloc.dart';
import 'modify_dog_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        builder: (BuildContext context, UserState state) {
      state as CompleteState;
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
                for (Dog dog in state.internalUser.dogs!)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: ShowText(
                      text: dog.name!,
                      title: 'Dog',
                      trailerIcon: Icons.arrow_forward_ios,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModifyDogScreen(
                            dog: dog,
                          ),
                        ),
                      ),
                    ),
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
                // ],
                // ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
