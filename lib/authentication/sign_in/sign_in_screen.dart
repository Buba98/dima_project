import 'package:dima_project/authentication/sign_in/sign_in_bloc.dart';
import 'package:dima_project/input/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../input/button.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final SignInBloc signInBloc = SignInBloc();

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
              BlocBuilder<SignInBloc, SignInState>(
                bloc: signInBloc,
                builder: (BuildContext context, SignInState state) {
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
                          error: state is UserNotFoundState,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextInput.password(
                          textEditingController: password,
                          error: state is WrongPasswordState,
                        ),
                        const Spacer(),
                        Button(
                          onPressed: () => signInBloc.add(
                            EmailPasswordSignInEvent(
                              email: email.text,
                              password: password.text,
                            ),
                          ),
                          text: 'Sign in',
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
