import 'package:dima_project/authentication/sign_up/sign_up_bloc.dart';
import 'package:dima_project/custom_widgets/app_bar.dart';
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
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<SignUpBloc, SignUpState>(
        bloc: signUpBloc,
        builder: (BuildContext context, SignUpState state) {
          return Center(
            child: SizedBox(
              width: 300,
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: Flex(
                      direction: Axis.vertical,
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
                                    "Welcome",
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
                              if (state is GenericErrorState)
                                Text(
                                  'Generic error',
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor),
                                ),
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
                                key: const Key('sign_up_button'),
                                onPressed: () => signUpBloc.add(
                                  EmailPasswordSignUpEvent(
                                    email: email.text,
                                    password: password.text,
                                  ),
                                ),
                                text: 'Sign Up',
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
