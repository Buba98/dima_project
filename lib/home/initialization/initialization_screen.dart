import 'dart:io';

import 'package:dima_project/custom_widgets/button.dart';
import 'package:dima_project/custom_widgets/text_input.dart';
import 'package:dima_project/home/settings/profile_picture.dart';
import 'package:dima_project/model/internal_user.dart';
import 'package:dima_project/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class InitializationScreen extends StatefulWidget {
  const InitializationScreen({
    super.key,
    required this.internalUser,
  });

  final InternalUser internalUser;

  @override
  State<StatefulWidget> createState() => _InitializationScreenState();
}

class _InitializationScreenState extends State<InitializationScreen> {
  final TextEditingController name = TextEditingController();

  bool nameError = false;
  File? image;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: ListView(
            children: [
              const SizedBox(
                height: 50,
              ),
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
                        modify: true,
                        backgroundImage: FileImage(image!),
                      );
                    }

                    return ProfilePicture(
                      modify: true,
                      backgroundImage:
                          (snapshot.connectionState == ConnectionState.done &&
                                  snapshot.hasData)
                              ? NetworkImage(snapshot.data!)
                              : null,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextInput(
                hintText: 'Enter your name',
                errorText: nameError ? 'Name is required' : null,
                textEditingController: name,
                icon: Icons.person,
              ),
              const SizedBox(
                height: 50,
              ),
              Button(
                onPressed: () {
                  if (name.text.isEmpty) {
                    setState(() => nameError = true);
                    return;
                  }
                  context.read<UserBloc>().add(
                        ModifyEvent(
                          name: name.text != widget.internalUser.name
                              ? name.text
                              : null,
                          image: image,
                        ),
                      );
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
