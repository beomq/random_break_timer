import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:random_break_timer/data/model/study_data.dart';
import 'package:random_break_timer/main.dart';
import 'package:random_break_timer/ui/input/study_time_input_screen.dart';
import 'package:random_break_timer/ui/my_page/my_page_screen.dart';
import 'package:random_break_timer/ui/result/result_screen.dart';
import 'package:random_break_timer/ui/widget/custom_bottom_navigation_bar.dart';
import 'package:random_break_timer/ui/widget/custom_button.dart';
import 'package:random_break_timer/ui/widget/custom_time_text.dart';

class TimerHomePage extends StatefulWidget {
  Duration totalStudyTime;
  Duration minBreakTime;
  Duration maxBreakTime;

  TimerHomePage({
    super.key,
    required this.totalStudyTime,
    required this.minBreakTime,
    required this.maxBreakTime,
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
  bool _isStudying = false;
  bool _isPause = false;
  List<Duration> _studyAndBreakTime = [];

  Duration getTotalStudyTime() {
    List<Duration> _oddIndexedNumbers = [];
    for (int i = 1; i < _studyAndBreakTime.length; i += 2) {
      _oddIndexedNumbers.add(_studyAndBreakTime[i]);
    }
    if (_oddIndexedNumbers.isEmpty) {
      return Duration.zero;
    }
    return _oddIndexedNumbers.reduce((a, b) => a + b);
  }

  Duration getTotalBreakTime() {
    List<Duration> _breakIndexedNumbers = [];
    for (int i = 0; i < _studyAndBreakTime.length; i += 2) {
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
    if (!_isStudying && _studyAndBreakTime.isNotEmpty) {
      _timer?.cancel();
      _studyAndBreakTime.add(_elapsedBreakTime);
      _elapsedBreakTime = Duration.zero;
    }
    _isPause = false;
    _isStudying = true;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_time != Duration.zero) {
          setState(() {
            _time -= const Duration(seconds: 1);
            _elapsedStudyTime += const Duration(seconds: 1);
          });
        }
      },
    );
  }

  void _stop() {
    _isPause = true;
    _timer?.cancel();
    setState(() {});
  }

  Duration getRandomDuration(Duration min, Duration max) {
    final random = Random();
    int range = max.inSeconds - min.inSeconds;

    int randomSeconds = random.nextInt(range + 1);
    return min + Duration(seconds: randomSeconds);
  }

  void _startBreakTime() {
    _timer?.cancel();
    if (_isStudying) {
      _studyAndBreakTime.add(_elapsedStudyTime);
      _elapsedStudyTime = Duration.zero;
    }
    _isPause = false;
    _isStudying = false;
    _breakTime = getRandomDuration(_minBreakTime, _maxBreakTime);
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
    String durationToString(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }

    String _formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String hours =
          duration.inHours != 0 ? "${twoDigits(duration.inHours)} : " : "";
      String minutes = duration.inMinutes != 0
          ? "${twoDigits(duration.inMinutes.remainder(60))} : "
          : '';
      String seconds = "${twoDigits(duration.inSeconds.remainder(60))}";

      return hours + minutes + seconds;
    }

    Column _buildStudyBreakPairs() {
      List<Widget> tiles = [];

      for (int i = 0; i < _studyAndBreakTime.length - 1; i += 2) {
        Duration studyDuration = _studyAndBreakTime[i];
        Duration breakDuration = _studyAndBreakTime[i + 1];

        tiles.add(
          ListTile(
            title: Text(
              '${(i / 2 + 1).toInt()}. 공부: ${_formatDuration(studyDuration)} 휴식: ${_formatDuration(breakDuration)}',
            ),
          ),
        );
      }

      return Column(children: tiles);
    }

    final String goalAchievement =
        (getTotalStudyTime().inSeconds / _time.inSeconds * 100).toString();
    double goalAchievementValue = double.parse(goalAchievement);

    void _showDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          double goalAchievementValue = double.parse(goalAchievement);
          String lottieAsset;
          if (goalAchievementValue >= 100) {
            lottieAsset = 'assets/100.json';
          } else if (goalAchievementValue >= 75) {
            lottieAsset = 'assets/80.json';
          } else if (goalAchievementValue >= 50) {
            lottieAsset = 'assets/60.json';
          } else {
            lottieAsset = 'assets/40.json';
          }
          return AlertDialog(
            title: Text('목표 달성도'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Lottie.asset(lottieAsset,
                      width: 200, height: 200, fit: BoxFit.cover),
                  Text('$goalAchievement %'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('My page'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPageScreen()),
                  );
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [Icon(Icons.add)],
      ),
      body: SingleChildScrollView(
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
                    border: Border.all(width: 1),
                    color: const Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    children: [
                      _isStudying
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset('assets/study.json',
                                    height: 200, fit: BoxFit.cover),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset('assets/breaktime.json',
                                    height: 200, fit: BoxFit.cover),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                      _isStudying
                          ? CustomTimeText(time: _time)
                          : CustomTimeText(time: _breakTime),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _isStudying && !_isPause
                        ? CustomButton(onPressed: () => _stop(), text: '일시정지')
                        : CustomButton(onPressed: () => _start(), text: '시작'),
                    !_isStudying && !_isPause
                        ? CustomButton(onPressed: () => _stop(), text: '일시정지')
                        : CustomButton(
                            onPressed: () => _startBreakTime(),
                            text: '쉬는시간 시작'),
                    CustomButton(
                      text: '공부 종료',
                      onPressed: () async {
                        _stop();
                        if (_isStudying) {
                          _studyAndBreakTime.add(_elapsedStudyTime);
                          _elapsedStudyTime = Duration.zero;
                        } else {
                          _studyAndBreakTime.add(_elapsedBreakTime);
                          _elapsedBreakTime = Duration.zero;
                        }
                        await datas.add(
                          StudyData(
                            date: DateTime.now().toString(),
                            totalStudyTime: getTotalStudyTime().toString(),
                            targetedStudyTime: _time.toString(),
                            totalBreakTime: getTotalBreakTime().toString(),
                            StudyAndBreakTime: _studyAndBreakTime,
                          ),
                        );

                        _showDialog(context);
                      },
                    )
                  ],
                ),
                _studyAndBreakTime.length >= 2
                    ? Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
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
    );
  }
}
