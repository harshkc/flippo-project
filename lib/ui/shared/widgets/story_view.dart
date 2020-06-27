import 'package:flippo/ui/shared/widgets/animated_circle_story.dart';
import 'package:flutter/material.dart';

class StoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (context, index) =>
              index == 0 ? noStory() : StoryCircle()),
    );
  }

  Widget noStory() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: CircleAvatar(
        backgroundColor: Color(0xffF0F0F1),
        radius: 35.0,
        child: Icon(
          Icons.add,
          size: 35.0,
          color: Color(0xff828699),
        ),
      ),
    );
  }
}
