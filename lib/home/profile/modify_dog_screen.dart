import 'package:dima_project/bloc/user/user_bloc.dart';
import 'package:dima_project/constants.dart';
import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/inline_selection.dart';
import 'package:dima_project/input/text_input.dart';
import 'package:dima_project/model/dog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModifyDogScreen extends StatefulWidget {
  const ModifyDogScreen({
    super.key,
    this.dog,
    required this.goBack,
  });

  final Dog? dog;
  final Function() goBack;

  @override
  State<StatefulWidget> createState() => _ModifyDogScreenState();
}

class _ModifyDogScreenState extends State<ModifyDogScreen> {
  final TextEditingController name = TextEditingController();
  bool sex = true;
  bool emptyName = false;

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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: spaceBetweenWidgets,
        ),
        child: ListView(
          children: [
            Image.asset(
              'assets/images/playing_dog.png',
              height: 300,
            ),
            const SizedBox(
              height: 20,
            ),
            TextInput(
              key: const Key('dog_name_input'),
              errorText: emptyName ? S.of(context).nameCannotBeEmpty : null,
              textEditingController: name,
              hintText: S.of(context).name,
              icon: Icons.pets,
            ),
            const SizedBox(
              height: 20,
            ),
            InlineSelection(
              first: S.of(context).male,
              firstLeadingIcon: Icons.male,
              second: S.of(context).female,
              secondLeadingIcon: Icons.female,
              value: sex,
              onChanged: (bool value) => setState(() => sex = value),
            ),
            const SizedBox(
              height: 20,
            ),
            if (widget.dog != null)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: spaceBetweenWidgets,
                ),
                child: Button(
                  onPressed: () {
                    context.read<UserBloc>().add(
                          DeleteDogEvent(
                            uid: widget.dog!.uid,
                          ),
                        );
                    widget.goBack();
                  },
                  text: S.of(context).deleteDog,
                  primary: false,
                  attention: true,
                ),
              ),
            Button(
              key: const Key('finalize_button'),
              onPressed: () {
                if (name.text.isEmpty) {
                  setState(() => emptyName = true);
                  return;
                }
                context.read<UserBloc>().add(
                      ModifyDogEvent(
                        uid: widget.dog != null ? widget.dog!.uid : null,
                        name: name.text,
                        sex: sex,
                      ),
                    );
                widget.goBack();
              },
              text: S.of(context).finalize,
            ),
          ],
        ),
      ),
    );
  }
}
