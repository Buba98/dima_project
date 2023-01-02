import 'package:dima_project/generated/l10n.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

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
                    S.of(context).loading,
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

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  int counter = 0;

  late List<Image> images = [
    for (int i = 0; i < 6; i++)
      Image.asset('assets/animations/running_dog/$i.png')
  ];

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);

    animation = Tween<double>(begin: 0, end: 6).animate(controller)
      ..addListener(() {
        if (animation.value.toInt() == counter) return;

        if (animation.value.toInt() >= 6) return;

        setState(() {
          counter = (animation.value.toInt());
        });
      });
    controller.repeat();
  }

  @override
  void didChangeDependencies() {
    for (int i = 0; i < 6; i++) {
      precacheImage(images[i].image, context);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return images[counter];
  }
}
