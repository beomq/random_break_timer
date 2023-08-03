import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Display the total study time, total break time, and goal achievement
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("Total Study Time: ..."),
            Text("Total Break Time: ..."),
            Text("Goal Achievement: ..."),
          ],
        ),
      ),
    );
  }
}
