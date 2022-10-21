import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/input/inline_selection.dart';
import 'package:dima_project/input/text_input.dart';
import 'package:flutter/material.dart';

class ModifyDogScreen extends StatelessWidget {
  ModifyDogScreen({super.key});

  final TextEditingController name = TextEditingController();

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
              TextInput(
                textEditingController: name,
                hintText: 'Name',
                icon: Icons.pets,
              ),
              const SizedBox(
                height: 20,
              ),
              const InlineSelection(
                first: 'Male',
                firstLeadingIcon: Icons.male,
                second: 'Female',
                secondLeadingIcon: Icons.female,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
