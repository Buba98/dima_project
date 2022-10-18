import 'package:dima_project/home/settings/profile_picture.dart';
import 'package:dima_project/user/internal_user.dart';
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
      child: Column(
        children: [
          ProfilePicture(
            profilePictureUrl: internalUser.profilePicture,
          ),
        ],
      ),
    );
  }
}
