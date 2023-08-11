import 'package:flutter/material.dart';
import 'package:random_break_timer/ui/result/result_screen.dart';

class TimerScreen extends StatelessWidget {
  final String goalStudyTime;
  final String minBreakTime;
  final String maxBreakTime;

  const TimerScreen(
      {Key? key,
      required this.goalStudyTime,
      required this.minBreakTime,
      required this.maxBreakTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('시간'),
      ),
      body: Column(
        children: [
          Text(goalStudyTime),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text('쉬는시간'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ResultScreen()),
                  // );
                },
                child: Text('공부종료'),
              ),
            ],
          ),
          Container()
        ],
      ),
    );
  }
}
