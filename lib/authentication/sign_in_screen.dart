import 'package:dima_project/custom_widgets/text_input.dart';
import 'package:flutter/material.dart';

import '../custom_widgets/button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
                    TextInput(
                      textEditingController: TextEditingController(),
                      hintText: 'Enter email',
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextInput(
                      textEditingController: TextEditingController(),
                      hintText: 'Enter email',
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Button(
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()),
                            ),
                        text: 'Sign in'),
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
