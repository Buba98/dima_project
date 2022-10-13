import 'package:dima_project/loading/loading_widget.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 2 / 3,
          heightFactor: 2 / 3,
          child: LoadingWidget(),
        ),
      ),
    );
  }
}
