import 'package:dima_project/authentication/authentication_screen.dart';
import 'package:dima_project/home/home_screen.dart';
import 'package:dima_project/home/offer/offer_bloc.dart';
import 'package:dima_project/user/authentication_bloc.dart';
import 'package:dima_project/user/user_bloc.dart' as user_bloc;
import 'package:dima_project/utils/scroll_behavior.dart';
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
    MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (BuildContext context) => AuthenticationBloc(),
          child: const MyApp(),
        ),
        BlocProvider(
          create: (BuildContext context) => user_bloc.UserBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => OfferBloc(),
        ),
      ],
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
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: child ?? const LoadingScreen(),
        );
      },
      title: 'Walk the dog',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            foregroundColor: Colors.black,
          ),
          fontFamily: 'OpenSans',
          primarySwatch: createMaterialColor(const Color(0xFF287762)),
          primaryColor: const Color(0xFF287762),
          scaffoldBackgroundColor: const Color(0xFFe5e1d5)),
      home: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (BuildContext context, AuthenticationState state) {
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
