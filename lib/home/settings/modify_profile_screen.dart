import 'dart:io';

import 'package:dima_project/custom_widgets/app_bar.dart';
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
  });

  final InternalUser internalUser;

  @override
  State<StatefulWidget> createState() => _ModifyProfileScreenState();
}

class _ModifyProfileScreenState extends State<ModifyProfileScreen> {
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
      appBar: const KAppBar(
        text: 'Modify profile',
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 12 / 13,
          child: ListView(
            children: [
              Stack(
                children: [
                  Align(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: GestureDetector(
                        onTap: () async {
                          final XFile? image = await ImagePicker()
                              .pickImage(source: ImageSource.camera);

                          if (image != null) {
                            setState(() => this.image = File(image.path));
                          }
                        },
                        child: FutureBuilder<String>(
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (image != null) {
                              return ProfilePicture(
                                modify: true,
                                backgroundImage: FileImage(image!),
                              );
                            }

                            return ProfilePicture(
                              modify: true,
                              backgroundImage: (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData)
                                  ? NetworkImage(snapshot.data!)
                                  : null,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: MediaQuery.of(context).size.width / 5,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.all(15),
                      child: const Icon(Icons.mode),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextInput(
                hintText: 'Enter your name',
                errorText: nameError ? 'Name is required' : null,
                textEditingController: name,
                icon: Icons.person,
              ),
              const SizedBox(
                height: 20,
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
