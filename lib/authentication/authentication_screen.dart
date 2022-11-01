import 'package:dima_project/authentication/sign_up/sign_up_screen.dart';
import 'package:dima_project/input/button.dart';
import 'package:flutter/material.dart';

import 'sign_in/sign_in_screen.dart';

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
              Expanded(
                child: Column(
                  children: const [
                    Spacer(
                      flex: 2,
                    ),
                    Center(
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
                    Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Spacer(),
                    Button(
                        key: const Key('sign_in_button'),
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()),
                            ),
                        text: 'Sign In'),
                    const SizedBox(
                      height: 50,
                    ),
                    Button(
                      key: const Key('sign_up_button'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      ),
                      text: 'Sign Up',
                      primary: false,
                    ),
                    const Spacer(),
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
