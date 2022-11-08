import 'package:dima_project/constants/constants.dart';
import 'package:dima_project/home/settings/modify_dog_screen.dart';
import 'package:dima_project/home/settings/setting_screen.dart';
import 'package:flutter/material.dart';

import '../../custom_widgets/app_bar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Widget? screen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        backBehaviour: screen != null
            ? () => setState(
                  () => screen = null,
                )
            : null,
        text: screen == null
            ? 'Profile'
            : screen is ModifyDogScreen
                ? 'Dog profile'
                : 'Modify profile',
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > Constants.tabletThreshold) {
            return Row(
              children: [
                Flexible(
                  flex: 2,
                  child: SettingScreen(
                    changeScreen: (Widget? screen) {
                      setState(() {
                        this.screen = screen;
                      });
                    },
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: screen ?? Container(),
                ),
              ],
            );
          } else {
            return screen ??
                SettingScreen(
                  changeScreen: (Widget? screen) {
                    setState(() {
                      this.screen = screen;
                    });
                  },
                );
          }
        },
      ),
    );
  }
}
