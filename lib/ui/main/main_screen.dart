import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:random_break_timer/core/status.dart';
import 'package:random_break_timer/data/model/study_data.dart';
import 'package:random_break_timer/ui/main/main_view_model.dart';

import 'package:random_break_timer/ui/widget/custom_button.dart';
import 'package:random_break_timer/ui/widget/custom_time_text.dart';

class TimerHomePage extends StatefulWidget {
  final Function() onMyPage;
  Duration totalStudyTime;
  Duration minBreakTime;
  Duration maxBreakTime;

  TimerHomePage({
    super.key,
    required this.totalStudyTime,
    required this.minBreakTime,
    required this.maxBreakTime,
    required this.onMyPage,
  });

  @override
  _TimerHomePageState createState() => _TimerHomePageState();
}

class _TimerHomePageState extends State<TimerHomePage> {
  Timer? _timer;
  late Duration _time;
  late Duration _minBreakTime;
  late Duration _maxBreakTime;
  late Duration _breakTime;
  Duration _elapsedStudyTime = Duration.zero;
  Duration _elapsedBreakTime = Duration.zero;

  bool _isPause = false;
  List<Duration> _studyAndBreakTime = [];
  final model = MainViewModel();
  StudyStatus currentStatus = StudyStatus.initial;

  Duration getTotalStudyTime() {
    List<Duration> _oddIndexedNumbers = [];
    for (int i = 0; i < _studyAndBreakTime.length; i += 2) {
      _oddIndexedNumbers.add(_studyAndBreakTime[i]);
    }
    if (_oddIndexedNumbers.isEmpty) {
      return Duration.zero;
    }
    if (_oddIndexedNumbers.length == 1) {
      return _oddIndexedNumbers[0];
    }
    return _oddIndexedNumbers.reduce((a, b) => a + b);
  }

  Duration getTotalBreakTime() {
    List<Duration> _breakIndexedNumbers = [];
    for (int i = 1; i < _studyAndBreakTime.length; i += 2) {
      _breakIndexedNumbers.add(_studyAndBreakTime[i]);
    }
    if (_breakIndexedNumbers.isEmpty) {
      return Duration.zero;
    }
    return _breakIndexedNumbers.reduce((a, b) => a + b);
  }

  @override
  void initState() {
    super.initState();
    _time = widget.totalStudyTime;
    _minBreakTime = widget.minBreakTime;
    _maxBreakTime = widget.maxBreakTime;
    _breakTime = Duration.zero;
  }

  void _start() {
    if (currentStatus == StudyStatus.breakTime &&
        _studyAndBreakTime.isNotEmpty) {
      _timer?.cancel();
      _studyAndBreakTime.add(_elapsedBreakTime);
      _elapsedBreakTime = Duration.zero;
    }
    _isPause = false;
    currentStatus = StudyStatus.studying;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_time != Duration.zero) {
        setState(() {
          _time -= const Duration(seconds: 1);
          _elapsedStudyTime += const Duration(seconds: 1);
        });
      } else {
        _studyAndBreakTime.add(_elapsedStudyTime);
        _elapsedStudyTime = Duration.zero;
        _timer?.cancel();
      }
    });
  }

  void _stop() {
    _isPause = true;
    _timer?.cancel();
    setState(() {});
  }

  void _startBreakTime() {
    _timer?.cancel();
    if (currentStatus == StudyStatus.studying) {
      _studyAndBreakTime.add(_elapsedStudyTime);
      _elapsedStudyTime = Duration.zero;
      _breakTime = model.getRandomDuration(_minBreakTime, _maxBreakTime);
    }
    _isPause = false;
    currentStatus = StudyStatus.breakTime;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_breakTime != Duration.zero) {
          setState(
            () {
              _breakTime -= const Duration(seconds: 1);
              _elapsedBreakTime += const Duration(seconds: 1);
            },
          );
        } else {
          _timer?.cancel();
          _start();
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Column _buildStudyBreakPairs() {
      List<Widget> tiles = [];

      for (int i = 0; i < _studyAndBreakTime.length - 1; i += 2) {
        Duration studyDuration = _studyAndBreakTime[i];
        Duration breakDuration = _studyAndBreakTime[i + 1];

        tiles.add(
          ListTile(
            title: Text(
              '${(i / 2 + 1).toInt()}. 공부: ${model.formatDuration(studyDuration)} 휴식: ${model.formatDuration(breakDuration)}',
            ),
          ),
        );
      }

      return Column(children: tiles);
    }

    final num goalAchievement =
        (getTotalStudyTime().inSeconds / widget.totalStudyTime.inSeconds * 100)
            .roundToDouble();

    void _showDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('목표 달성도'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Lottie.asset('assets/finish.json',
                      width: 200, height: 200, fit: BoxFit.cover),
                  goalAchievement.isNaN
                      ? Text(
                          '0%',
                          style: TextStyle(fontSize: 20),
                        )
                      : Text(
                          '$goalAchievement %',
                          style: TextStyle(fontSize: 20),
                        ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('My page'),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onMyPage();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hello User',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      color: const Color(0xFFFFFFFF),
                    ),
                    child: Column(
                      children: [
                        if (currentStatus == StudyStatus.studying)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/study.json',
                                  height: 200, fit: BoxFit.cover),
                              const SizedBox(height: 30),
                            ],
                          )
                        else if (currentStatus == StudyStatus.breakTime)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/breaktime.json',
                                  height: 200, fit: BoxFit.cover),
                              const SizedBox(height: 30),
                            ],
                          )
                        else if (currentStatus == StudyStatus.initial)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/finish2.json',
                                  height: 200, fit: BoxFit.cover),
                              const SizedBox(height: 30),
                            ],
                          )
                        else
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/study.json',
                                  height: 200, fit: BoxFit.cover),
                              const SizedBox(height: 30),
                            ],
                          ),
                        if (currentStatus != StudyStatus.initial &&
                            currentStatus != StudyStatus.finished)
                          CustomTimeText(
                              time: currentStatus == StudyStatus.studying
                                  ? _time
                                  : _breakTime),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      currentStatus == StudyStatus.studying && !_isPause
                          ? CustomButton(
                              onPressed: () => _stop(), text: 'Study Pause')
                          : CustomButton(
                              onPressed: () => _start(), text: 'Study Start'),
                      currentStatus == StudyStatus.initial
                          ? CustomButton(
                              onPressed: (null), text: '◀️ Click Here')
                          : currentStatus == StudyStatus.breakTime && !_isPause
                              ? CustomButton(
                                  onPressed: () => _stop(),
                                  text: 'Break Time Pause')
                              : CustomButton(
                                  onPressed: () => _startBreakTime(),
                                  text: 'Break Time Start'),
                      currentStatus == StudyStatus.initial
                          ? CustomButton(onPressed: (null), text: 'finish')
                          : CustomButton(
                              text: 'Finish',
                              onPressed: () async {
                                _stop();
                                if (currentStatus == StudyStatus.studying) {
                                  _studyAndBreakTime.add(_elapsedStudyTime);
                                  _elapsedStudyTime = Duration.zero;
                                  _studyAndBreakTime.add(Duration.zero);
                                } else {
                                  _studyAndBreakTime.add(_elapsedBreakTime);
                                  _elapsedBreakTime = Duration.zero;
                                }
                                currentStatus = StudyStatus.initial;
                                await model.saveStudyData(
                                  StudyData(
                                    date: model.formatDate(DateTime.now()),
                                    totalStudyTime:
                                        getTotalStudyTime().toString(),
                                    targetedStudyTime:
                                        widget.totalStudyTime.toString(),
                                    totalBreakTime:
                                        getTotalBreakTime().toString(),
                                    studyAndBreakTime: _studyAndBreakTime,
                                  ),
                                );

                                _showDialog(context);
                              },
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _studyAndBreakTime.length >= 2
                      ? Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            color: const Color(0xFFE7E7E7),
                          ),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text('공부 시간'),
                              ),
                              _buildStudyBreakPairs(),
                            ],
                          ))
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
