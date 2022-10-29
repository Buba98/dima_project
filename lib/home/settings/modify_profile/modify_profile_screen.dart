import 'dart:io';

import 'package:dima_project/home/settings/profile_picture.dart';
import 'package:dima_project/input/button.dart';
import 'package:dima_project/input/text_input.dart';
import 'package:dima_project/model/internal_user.dart';
import 'package:dima_project/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ModifyProfileScreen extends StatefulWidget {
  const ModifyProfileScreen({
    super.key,
    required this.internalUser,
    this.goBack,
  });

  final Function()? goBack;
  final InternalUser internalUser;

  @override
  State<StatefulWidget> createState() => _ModifyProfileScreenState();
}

class _ModifyProfileScreenState extends State<ModifyProfileScreen> {
  final TextEditingController name = TextEditingController();

  bool emptyName = false;
  File? image;

  @override
  void initState() {
    if (widget.internalUser.name != null) {
      name.text = widget.internalUser.name!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) =>
                  GestureDetector(
                onTap: () async {
                  final XFile? image =
                      await ImagePicker().pickImage(source: ImageSource.camera);

                  if (image != null) {
                    setState(() => this.image = File(image.path));
                  }
                },
                child: FutureBuilder<String>(
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (image != null) {
                      return ProfilePicture(
                        radius: constraints.maxWidth / 2,
                        modify: true,
                        image: FileImage(image!),
                      );
                    }

                    return ProfilePicture(
                      radius: constraints.maxWidth / 4,
                      modify: true,
                      image:
                          (snapshot.connectionState == ConnectionState.done &&
                                  snapshot.hasData)
                              ? NetworkImage(snapshot.data!)
                              : null,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextInput(
              hintText: 'Enter your name',
              errorText: emptyName ? 'Name is required' : null,
              textEditingController: name,
              icon: Icons.person,
            ),
            const SizedBox(
              height: 20,
            ),
            Button(
              onPressed: () {
                if (name.text.isEmpty) {
                  setState(() => emptyName = true);
                  return;
                }
                context.read<UserBloc>().add(
                      ModifyEvent(
                        name: name.text,
                        image: image,
                      ),
                    );
                if (widget.goBack != null) {
                  widget.goBack!();
                }
              },
              text: 'Finalize',
            ),
          ],
        ),
      ),
    );
  }
}