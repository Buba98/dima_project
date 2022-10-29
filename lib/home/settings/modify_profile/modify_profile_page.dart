import 'package:dima_project/home/settings/modify_profile/modify_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../user/user_bloc.dart';

class ModifyProfilePage extends StatelessWidget {
  const ModifyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        builder: (BuildContext context, UserState state) {
          return Center(
            child: SizedBox(
              width: 300,
              child: ModifyProfileScreen(
                internalUser: (state as InitializedState).internalUser,
              ),
            ),
          );
        },
      ),
    );
  }
}
