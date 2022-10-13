import 'package:dima_project/authentication/authentication_screen.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: 'OpenSans',
          primarySwatch: createMaterialColor(const Color(0xFF287762)),
          scaffoldBackgroundColor: const Color(0xFFe5e1d5)),
      home: BlocListener<UserBloc, UserState>(
        listener: (BuildContext context, UserState state) {
          if (state is InitializationState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoadingScreen()),
                (route) => false);
          } else if (state is UnauthenticatedState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const AuthenticationScreen()),
                (route) => false);
          } else if (state is UnverifiedState) {
          } else if (state is AuthenticatedState) {}
        },
        child: const LoadingScreen(),
      ),
    );
  }
}
