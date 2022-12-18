import 'package:dima_project/authentication/authentication_screen.dart';
import 'package:dima_project/bloc/location_bloc.dart';
import 'package:dima_project/bloc/offer_bloc.dart';
import 'package:dima_project/bloc/user/authentication_bloc.dart';
import 'package:dima_project/bloc/user/user_bloc.dart' as user_bloc;
import 'package:dima_project/chat/chat_page.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/firebase_options.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/home/home_screen.dart';
import 'package:dima_project/loading/loading_screen.dart';
import 'package:dima_project/utils/scroll_behavior.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        BlocProvider(
          create: (BuildContext context) => LocationBloc(),
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
      localizationsDelegates: const [
        S.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
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
        primarySwatch: createMaterialColor(primaryColor),
        primaryColor: primaryColor,
        scaffoldBackgroundColor: secondaryColor,
      ),
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
