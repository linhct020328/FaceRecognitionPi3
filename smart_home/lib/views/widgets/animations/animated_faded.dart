import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class FadedAnimated extends StatefulWidget {
  final Widget child;
  final int timeMiSecond;

  FadedAnimated({this.child, this.timeMiSecond})
      : assert(timeMiSecond != null && child != null);

  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<FadedAnimated> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: widget.timeMiSecond), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    /*animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });*/

    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: animation, child: widget.child);
  }
}
