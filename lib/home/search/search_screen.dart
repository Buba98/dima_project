import 'package:dima_project/custom_widgets/app_bar.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KAppBar(
        text: 'Search',
      ),
      body: ListView(
        shrinkWrap: true,
        children: [],
      ),
    );
  }
}
