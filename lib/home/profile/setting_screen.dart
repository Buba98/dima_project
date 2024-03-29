import 'package:dima_project/bloc/user/authentication_bloc.dart';
import 'package:dima_project/bloc/user/user_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/profile/modify_dog_screen.dart';
import 'package:dima_project/home/profile/modify_profile/modify_profile_screen.dart';
import 'package:dima_project/home/profile/profile_picture.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/show_text.dart';
import 'package:dima_project/model/dog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key, required this.changeScreen});

  final Function(Widget?) changeScreen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (BuildContext context, UserState state) {
        state as CompleteState;
        return Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: spaceBetweenWidgets),
            child: ListView(
              children: [
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return FutureBuilder<String>(
                      future: state.internalUser.profilePicture,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return ProfilePicture(
                          radius: constraints.maxWidth / 4,
                          image: snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData
                              ? NetworkImage(snapshot.data!)
                              : null,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ShowText(
                  title: S.of(context).name,
                  text: state.internalUser.name!,
                ),
                if (state.internalUser.bio != null) ...[
                  const SizedBox(
                    height: 20,
                  ),
                  ShowText(
                    title: S.of(context).biography,
                    text: state.internalUser.bio!,
                  ),
                ],
                const SizedBox(
                  height: 20,
                ),
                Button(
                  onPressed: () => changeScreen(
                    ModifyProfileScreen(
                      internalUser: state.internalUser,
                      goBack: () => changeScreen(null),
                    ),
                  ),
                  text: S.of(context).modify,
                ),
                const Divider(),
                for (Dog dog in state.internalUser.dogs!)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: ShowText(
                      text: dog.name!,
                      title: S.of(context).dog,
                      trailerIcon: Icons.arrow_forward_ios,
                      onPressed: () => changeScreen(
                        ModifyDogScreen(
                          dog: dog,
                          goBack: () => changeScreen(null),
                        ),
                      ),
                    ),
                  ),
                Button(
                  onPressed: () => changeScreen(
                    ModifyDogScreen(
                      goBack: () => changeScreen(null),
                    ),
                  ),
                  text: S.of(context).addNewDog,
                ),
                const Divider(),
                Button(
                  attention: true,
                  onPressed: () =>
                      context.read<AuthenticationBloc>().add(SignOutEvent()),
                  text: S.of(context).signOut,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
