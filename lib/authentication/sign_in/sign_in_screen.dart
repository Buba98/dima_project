import 'package:dima_project/authentication/sign_in/sign_in_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/custom_widgets/scroll_expandable.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final SignInBloc signInBloc = SignInBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        backBehaviour: () => Navigator.pop(context),
      ),
      body: BlocBuilder<SignInBloc, SignInState>(
        bloc: signInBloc,
        builder: (BuildContext context, SignInState state) {
          return ScrollExpandable(
            child: Center(
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
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "Welcome",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 110,
                                fontFamily: 'Pacifico',
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
                          if (state is GenericErrorState)
                            Text(
                              'Generic error',
                              style: TextStyle(
                                  color: Theme.of(context).errorColor),
                            ),
                          const Spacer(),
                          TextInput.email(
                            textEditingController: email,
                            error: state is UserNotFoundState,
                          ),
                          const SizedBox(
                            height: spaceBetweenWidgets,
                          ),
                          TextInput.password(
                            textEditingController: password,
                            error: state is WrongPasswordState,
                          ),
                          const SizedBox(
                            height: spaceBetweenWidgets,
                          ),
                          Button(
                            key: const Key('sign_in_button'),
                            onPressed: () => signInBloc.add(
                              EmailPasswordSignInEvent(
                                email: email.text,
                                password: password.text,
                              ),
                            ),
                            text: 'Sign In',
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
        },
      ),
    );
  }
}
