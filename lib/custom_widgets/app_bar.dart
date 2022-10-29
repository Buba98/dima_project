import 'package:flutter/material.dart';

class KAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KAppBar({super.key, this.text, this.backBehaviour});

  final String? text;
  final Function()? backBehaviour;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: backBehaviour != null
          ? GestureDetector(
              child: const Icon(
                Icons.arrow_back_ios,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
