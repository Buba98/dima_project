import 'package:dima_project/home/initialization/initialization_screen.dart';
import 'package:dima_project/home/search/search_screen.dart';
import 'package:dima_project/home/settings/setting_screen.dart';
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
          home = InitializationScreen();
        } else if (state is InitializedState) {
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
    const SettingScreen(),
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walk the dog'),
      ),
      body: bodyList[currentIndex],
      bottomNavigationBar: BottomBar(
        currentIndex: currentIndex,
        onTap: (int index) => setState(() => currentIndex = index),
      ),
    );
  }
}
