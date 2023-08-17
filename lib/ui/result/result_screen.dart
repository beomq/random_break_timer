import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String goalAchievement;

  const ResultScreen({
    Key? key,
    required this.goalAchievement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(goalAchievement),
      ),
    );
  }
}
