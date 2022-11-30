import 'package:dima_project/home/offer/create_offer_page.dart';
import 'package:dima_project/home/offer/offer_bloc.dart';
import 'package:dima_project/home/search/search_screen.dart';
import 'package:dima_project/home/settings/modify_profile/modify_profile_page.dart';
import 'package:dima_project/home/settings/setting_page.dart';
import 'package:dima_project/loading/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../custom_widgets/bottom_bar.dart';
import '../user/user_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget home = const LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (BuildContext context, UserState state) {
        Navigator.popUntil(context, (route) => route.isFirst);

        Widget home = const LoadingScreen();

        if (state is NotInitializedState) {
          home = const ModifyProfilePage();
        } else if (state is CompleteState) {
          home = _Home();
        }

        setState(
          () => this.home = home,
        );
      },
      child: home,
    );
  }
}

class _Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  List<Widget> bodyList = [
    const SearchScreen(),
    const CreateOfferPage(),
    const SettingPage(),
  ];
  int currentIndex = 0;

  @override
  void initState() {
    context.read<OfferBloc>().add(LoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyList[currentIndex],
      bottomNavigationBar: BottomBar(
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() => currentIndex = index);
        },
      ),
    );
  }
}
