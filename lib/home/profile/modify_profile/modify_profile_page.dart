import 'package:dima_project/bloc/user/user_bloc.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/profile/modify_profile/modify_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModifyProfilePage extends StatelessWidget {
  const ModifyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(text: S.of(context).modifyProfile,),
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
