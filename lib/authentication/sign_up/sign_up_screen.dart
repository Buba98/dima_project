import 'package:dima_project/authentication/sign_up/sign_up_bloc.dart';
import 'package:dima_project/input/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../input/button.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final SignUpBloc signUpBloc = SignUpBloc();

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
              BlocBuilder<SignUpBloc, SignUpState>(
                bloc: signUpBloc,
                builder: (BuildContext context, SignUpState state) {
                  return Expanded(
                    child: Column(
                      children: [
                        if (state is GenericErrorState)
                          Text(
                            'Generic error',
                            style:
                                TextStyle(color: Theme.of(context).errorColor),
                          ),
                        const Spacer(),
                        TextInput.email(
                          textEditingController: email,
                          error: state is UserAlreadyExistsState,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextInput.password(
                          textEditingController: password,
                          error: state is WeekPasswordState,
                        ),
                        const Spacer(),
                        Button(
                          onPressed: () => signUpBloc.add(
                            EmailPasswordSignUpEvent(
                              email: email.text,
                              password: password.text,
                            ),
                          ),
                          text: 'Sign up',
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
