import 'package:dima_project/custom_widgets/button.dart';
import 'package:dima_project/custom_widgets/text_input.dart';
import 'package:dima_project/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitializationScreen extends StatelessWidget {
  InitializationScreen({super.key});

  final TextEditingController name = TextEditingController();

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
                          "Finalize profile",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 110,
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
                    TextInput(
                      hintText: 'Enter your name',
                      textEditingController: name,
                      icon: Icons.person,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Button(
                      onPressed: () {
                        if (name.text.isEmpty) {
                          return;
                        }
                        context.read<UserBloc>().add(
                              ModifyEvent(
                                name: name.text,
                              ),
                            );
                      },
                      text: 'Finalize',
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
