import 'package:dima_project/custom_widgets/button.dart';
import 'package:flutter/material.dart';

import 'sign_in_screen.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            children: [
              const Expanded(
                flex: 3,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      "Walk the dog",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 110,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Button(
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()),
                            ),
                        text: 'Sign in'),
                    const SizedBox(
                      height: 50,
                    ),
                    Button(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()),
                      ),
                      text: 'Sign up',
                      primary: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
