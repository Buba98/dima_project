import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/inline_selection.dart';
import 'package:dima_project/input/text_input.dart';
import 'package:dima_project/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/dog.dart';

class ModifyDogScreen extends StatefulWidget {
  const ModifyDogScreen({
    super.key,
    this.dog,
  });

  final Dog? dog;

  @override
  State<StatefulWidget> createState() => _ModifyDogScreenState();
}

class _ModifyDogScreenState extends State<ModifyDogScreen> {
  final TextEditingController name = TextEditingController();
  bool sex = true;

  @override
  void initState() {
    if (widget.dog != null) {
      name.text = widget.dog!.name!;
      sex = widget.dog!.sex!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        text: widget.dog != null ? 'Create dog' : 'Modify dog',
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
              if (widget.dog != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Button(
                    onPressed: () => context.read<UserBloc>().add(
                          DeleteDogEvent(
                            uid: widget.dog!.uid,
                          ),
                        ),
                    text: 'Delete dog',
                    primary: false,
                  ),
                ),
              Button(
                onPressed: () {
                  context.read<UserBloc>().add(
                        ModifyDogEvent(
                          uid: widget.dog != null ? widget.dog!.uid : null,
                          name: name.text,
                          sex: sex,
                        ),
                      );
                  Navigator.pop(context);
                },
                text: 'Finalize',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
