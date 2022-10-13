import 'package:flutter/material.dart';

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

  late List<Image> images = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 6; i++) {
      images.add(Image.asset('assets/animations/running_dog/$i.png'));
    }

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
