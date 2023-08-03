import 'dart:async';

import 'package:flutter/material.dart';
import 'package:random_break_timer/ui/result_screen.dart';

String formatDuration(Duration d) {
  final seconds = d.inSeconds;
  final hours = (seconds / 3600).floor();
  final minutes = ((seconds % 3600) / 60).floor();
  final remainingSeconds = seconds % 60;

  final hoursStr = (hours < 10 ? '0' : '') + hours.toString();
  final minutesStr = (minutes < 10 ? '0' : '') + minutes.toString();
  final secondsStr =
      (remainingSeconds < 10 ? '0' : '') + remainingSeconds.toString();

  return '$hoursStr:$minutesStr:$secondsStr';
}

class TimerScreen extends StatefulWidget {
  final int studyTime;
  final int breakTime;

  TimerScreen({required this.studyTime, required this.breakTime});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool isStudying = true;
  Timer? _timer;

  Duration? studyTimeLeft;
  Duration? breakTimeLeft;

  @override
  void initState() {
    super.initState();
    studyTimeLeft = Duration(minutes: widget.studyTime);
    breakTimeLeft = Duration(minutes: widget.breakTime);
  }

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (isStudying) {
          if (studyTimeLeft > 0) {
            studyTimeLeft = studyTimeLeft - Duration(seconds: 1);
          }
        } else {
          if (breakTimeLeft > 0) {
            breakTimeLeft = breakTimeLeft - Duration(seconds: 1);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("Study Time: ${widget.studyTime}"),
            Text("Break Time: ${widget.breakTime}"),
            ElevatedButton(
              onPressed: () {
                // TODO: Start break timer
              },
              child: Text("Break"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ResultScreen(),
                  ),
                );
              },
              child: Text("Study Complete"),
            ),
          ],
        ),
      ),
    );
  }
}
