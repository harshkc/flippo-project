import 'package:dashed_circle/dashed_circle.dart';
import 'package:flippo/ui/shared/constant.dart';
import 'package:flutter/material.dart';

class StoryCircle extends StatefulWidget {
  @override
  _StoryCircleState createState() => _StoryCircleState();
}

class _StoryCircleState extends State<StoryCircle>
    with SingleTickerProviderStateMixin {
  /// Variables
  Animation gap;
  Animation base;
  Animation reverse;
  AnimationController controller;

  /// Init
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    base = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    reverse = Tween<double>(begin: 0.0, end: -1.0).animate(base);
    gap = Tween<double>(begin: 3.0, end: 0.0).animate(base)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  /// Dispose
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      alignment: Alignment.center,
      child: RotationTransition(
        turns: base,
        child: DashedCircle(
          gapSize: gap.value,
          dashes: 35,
          color: kPrimaryColor,
          child: RotationTransition(
            turns: reverse,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage("assets/momento.PNG"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
