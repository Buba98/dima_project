import 'package:dima_project/constants.dart';
import 'package:flutter/material.dart';

class KAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KAppBar({
    super.key,
    this.text,
    this.backBehaviour,
    this.actionIcon,
    this.actionFunction,
  });

  final String? text;
  final Function()? backBehaviour;
  final IconData? actionIcon;
  final Function()? actionFunction;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (backBehaviour != null) {
          backBehaviour!();
          Navigator.of(context).pop(false);
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: AppBar(
        actions: [
          if (actionIcon != null && actionFunction != null)
            Padding(
              padding: const EdgeInsets.only(right: spaceBetweenWidgets / 2),
              child: GestureDetector(
                onTap: actionFunction,
                child: Icon(
                  actionIcon!,
                  color: Colors.black,
                ),
              ),
            ),
        ],
        leading: backBehaviour != null
            ? GestureDetector(
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onTap: () => backBehaviour!(),
              )
            : null,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: text != null
            ? Text(
                text!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
