import 'package:dima_project/authentication/authentication_screen.dart';
import 'package:dima_project/home/home_screen.dart';
import 'package:dima_project/user/user_bloc.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'loading/loading_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    BlocProvider(
      lazy: false,
      create: (BuildContext context) => UserBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Widget home = const LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Walk the dog',
      theme: ThemeData(
          fontFamily: 'OpenSans',
          primarySwatch: createMaterialColor(const Color(0xFF287762)),
          scaffoldBackgroundColor: const Color(0xFFe5e1d5)),
      home: BlocListener<UserBloc, UserState>(
        listener: (BuildContext context, UserState state) {
          Navigator.popUntil(context, (route) => route.isFirst);

          Widget home = const LoadingScreen();

          if (state is InitializationState) {
            home = const LoadingScreen();
          } else if (state is UnauthenticatedState) {
            home = const AuthenticationScreen();
          } else if (state is AuthenticatedState) {
            home = const HomeScreen();
          }
          setState(() {
            this.home = home;
          });
        },
        child: home,
      ),
    );
  }
}
