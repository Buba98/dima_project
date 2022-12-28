import 'package:dima_project/authentication/sign_up/sign_up_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/custom_widgets/scroll_expandable.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final SignUpBloc signUpBloc = SignUpBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        backBehaviour: () => Navigator.pop(context),
      ),
      body: BlocBuilder<SignUpBloc, SignUpState>(
        bloc: signUpBloc,
        builder: (BuildContext context, SignUpState state) {
          return ScrollExpandable(
            child: Center(
              child: SizedBox(
                width: 300,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Spacer(
                            flex: 2,
                          ),
                          Center(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                S.of(context).signUp,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 110,
                                  fontFamily: 'Pacifico',
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          if (state is GenericErrorState)
                            Text(
                              S.of(context).genericError,
                              style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          const Spacer(),
                          TextInput.email(
                            textEditingController: email,
                            errorText: state is UserAlreadyExistsState
                                ? S.of(context).emailAlreadyRegistered
                                : null,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          TextInput.password(
                            textEditingController: password,
                            errorText: state is WeekPasswordState
                                ? S.of(context).passwordTooWeak
                                : null,
                          ),
                          const SizedBox(
                            height: spaceBetweenWidgets,
                          ),
                          Button(
                            key: const Key('sign_up_button'),
                            onPressed: () => signUpBloc.add(
                              EmailPasswordSignUpEvent(
                                email: email.text,
                                password: password.text,
                              ),
                            ),
                            text: S.of(context).signUp,
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
