import 'package:flutter/material.dart';
import 'dart:async';

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StudyTimer(),
    );
  }
}

class StudyTimer extends StatefulWidget {
  @override
  _StudyTimerState createState() => _StudyTimerState();
}

class _StudyTimerState extends State<StudyTimer> {
  Duration studyTimeLeft =
      Duration(minutes: 60); // Example: 60 minutes of study
  Duration breakTimeLeft =
      Duration(minutes: 15); // Example: 15 minutes of break
  bool isStudying =
      true; // Indicates whether user is currently studying or on break
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (isStudying) {
          if (studyTimeLeft.inSeconds > 0) {
            studyTimeLeft = studyTimeLeft - Duration(seconds: 1);
          }
        } else {
          if (breakTimeLeft.inSeconds > 0) {
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
      appBar: AppBar(
        title: Text('Study Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isStudying ? 'Study Time Left' : 'Break Time Left',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 20),
            Text(
              formatDuration(isStudying ? studyTimeLeft : breakTimeLeft),
              style: TextStyle(fontSize: 60),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              child: Text(
                isStudying ? 'Start Break' : 'Start Studying',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                setState(() {
                  isStudying = !isStudying;
                  startTimer();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MyApp());
