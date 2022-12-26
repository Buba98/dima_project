import 'package:dima_project/generated/l10n.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  final Function(int) onTap;
  final int currentIndex;

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  late int _selectedIndex;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTap(index);
  }

  @override
  void initState() {
    _selectedIndex = widget.currentIndex;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedIconTheme: const IconThemeData(size: 30),
      unselectedIconTheme: const IconThemeData(size: 20),
      elevation: 0,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: Colors.transparent,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.search,
            key: Key('search_menu'),
          ),
          label: S.of(context).home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.add,
            key: Key('add_menu'),
          ),
          label: S.of(context).add,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.message_outlined,
            key: Key('messages_menu'),
          ),
          label: S.of(context).chat,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.settings,
            key: Key('settings_menu'),
          ),
          label: S.of(context).settings,
        ),
      ],
    );
  }

  Size get preferredSize => const Size.fromHeight(kBottomNavigationBarHeight);
}
