import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/inline_selection.dart';
import 'package:dima_project/input/text_input.dart';
import 'package:dima_project/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModifyDogScreen extends StatefulWidget {
  const ModifyDogScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ModifyDogScreenState();
}

class _ModifyDogScreenState extends State<ModifyDogScreen> {
  final TextEditingController name = TextEditingController();
  bool sex = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KAppBar(
        text: 'Modify dog',
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 12 / 13,
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/playing_dog.png',
              ),
              const SizedBox(
                height: 20,
              ),
              TextInput(
                textEditingController: name,
                hintText: 'Name',
                icon: Icons.pets,
              ),
              const SizedBox(
                height: 20,
              ),
              InlineSelection(
                first: 'Male',
                firstLeadingIcon: Icons.male,
                second: 'Female',
                secondLeadingIcon: Icons.female,
                value: sex,
                onChanged: (bool value) => setState(() => sex = value),
              ),
              const SizedBox(
                height: 20,
              ),
              Button(
                onPressed: () => context
                    .read<UserBloc>()
                    .add(ModifyDogEvent(name: name.text, sex: sex)),
                text: 'Modify dog',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
