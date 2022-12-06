import 'package:dima_project/generated/l10n.dart';
import 'package:dima_project/loading/loading_widget.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key, this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Expanded(
                flex: 2,
                child: LoadingWidget(),
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    text ?? S.of(context).loading,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 110,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
