import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Timer? _timer;
  int _totalStudyTime = 0;
  int _studyTime = 0;
  int _breakTime = 0;
  int _totalBreakTime = 0;
  int _breakTimeMin = 0;
  int _breakTimeMax = 0;
  int _stdTime = 0;
  bool _isStudying = false;

  void startTimer() {
    _isStudying = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_studyTime > 0) {
          _studyTime--;
          _totalStudyTime++;
          _stdTime++;
        } else {
          timer.cancel();
          _isStudying = false;
          startBreakTimer();
        }
      });
    });
  }

  void startBreakTimer() {
    _isStudying = false;
    _breakTime = _getRandomBreakTime();
    _totalBreakTime += _breakTime;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_breakTime > 0) {
          _breakTime--;
        } else {
          timer.cancel();
          _isStudying = true;
          if (_totalStudyTime > 0) {
            startTimer();
          }
        }
      });
    });
  }

  int _getRandomBreakTime() {
    return Random().nextInt(_breakTimeMax - _breakTimeMin + 1) + _breakTimeMin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Timer"),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                _totalStudyTime = int.parse(value) * 60; // minutes to seconds
                _studyTime = _totalStudyTime;
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: "Enter total study time (minutes)"),
            ),
            TextField(
              onChanged: (value) {
                _breakTimeMin = int.parse(value);
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: "Enter minimum break time (seconds)"),
            ),
            TextField(
              onChanged: (value) {
                _breakTimeMax = int.parse(value);
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: "Enter maximum break time (seconds)"),
            ),
            _breakTime == 0 && _studyTime != 0
                ? Text("Study time left: ${_studyTime}s")
                : Text("Break time left: ${_breakTime}s"),
            ElevatedButton(
              onPressed: () {
                if (!_isStudying && _totalStudyTime > 0) {
                  startTimer();
                }
              },
              child: const Text("Start studying"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_isStudying) {
                  _timer!.cancel();
                  startBreakTimer();
                }
              },
              child: const Text("Take a break"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_isStudying || !_isStudying) {
                  _timer!.cancel();
                  _isStudying = false;
                  print("Total break time: ${_totalBreakTime}s");
                  print("Total study time: ${_totalStudyTime}s");
                }
              },
              child: const Text("Stop studying"),
            ),
          ],
        ),
      ),
    );
  }
}
