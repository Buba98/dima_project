import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:dima_project/home/settings/modify_dog_screen.dart';
import 'package:dima_project/home/settings/setting_screen.dart';
import 'package:dima_project/utils/utils.dart';
import 'package:flutter/material.dart';

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
      body: isTablet(context)
          ? Row(
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
            )
          : screen ??
              SettingScreen(
                changeScreen: (Widget? screen) {
                  setState(() {
                    this.screen = screen;
                  });
                },
              ),
    );
  }
}
