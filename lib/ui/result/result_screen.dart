import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Duration totalStudyTime;
  final Duration totalbreakTime;
  const ResultScreen({
    Key? key,
    required this.totalStudyTime,
    required this.totalbreakTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공부완료'),
      ),
    );
  }
}
