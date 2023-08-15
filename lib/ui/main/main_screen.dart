import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
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

  @override
  void initState() {
    super.initState();
    _time = widget.totalStudyTime;
    _minBreakTime = widget.minBreakTime;
    _maxBreakTime = widget.maxBreakTime;
    _breakTime = Duration.zero;
  }

  void _start() {
    _stop();
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

    if (range < 0) {
      throw ArgumentError('max Duration should be greater than min Duration');
    }

    int randomSeconds = random.nextInt(range + 1);
    return min + Duration(seconds: randomSeconds);
  }

  void _startBreakTime() {
    _stop();
    _studyAndBreakTime.add(_elapsedStudyTime);
    _elapsedStudyTime = Duration.zero;
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
          _stop();
          _studyAndBreakTime.add(_elapsedBreakTime);
          _elapsedBreakTime = Duration.zero;
          _start();
        }
      },
    );
  }

  void _showModal(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String totalStudyTime = '';
    String minBreakTime = '';
    String maxBreakTime = '';

    Duration timeStringToSeconds(String timeString) {
      if (timeString.length == 5) {
        final parts = timeString.split(':');
        int minutes = int.parse(parts[0]);
        int seconds = int.parse(parts[1]);
        return Duration(minutes: minutes, seconds: seconds);
      } else {
        final parts = timeString.split(':');
        int hours = int.parse(parts[0]);
        int minutes = int.parse(parts[1]);
        int seconds = int.parse(parts[2]);
        return Duration(hours: hours, minutes: minutes, seconds: seconds);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      final formKeyState = formKey.currentState!;
                      if (formKeyState.validate()) {
                        formKeyState.save();
                        final minTime = timeStringToSeconds(minBreakTime);
                        final maxTime = timeStringToSeconds(maxBreakTime);

                        if (minTime > maxTime) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('쉬는 시간의 범위를 확인 해 주세요'),
                              duration: Duration(seconds: 1), // 메시지 표시 시간 설정
                            ),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TimerHomePage(
                                    totalStudyTime:
                                        timeStringToSeconds(totalStudyTime),
                                    minBreakTime:
                                        timeStringToSeconds(minBreakTime),
                                    maxBreakTime:
                                        timeStringToSeconds(maxBreakTime),
                                  )),
                        );
                      }
                    },
                    child: const Text('Start Study')))
          ],
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  onSaved: (value) => totalStudyTime = value!,
                  decoration: const InputDecoration(
                      hintText: 'ex) 11:11:11',
                      labelStyle: TextStyle(
                        fontSize: 11,
                      ),
                      labelText: '총 공부시간'),
                  validator: (value) {
                    if (!RegExp(r'^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$')
                        .hasMatch(value!)) {
                      return '올바른 시간 형식을 입력해주세요 ';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onSaved: (value) => minBreakTime = value!,
                        decoration: const InputDecoration(
                          hintText: 'ex) 11:11',
                          labelStyle: TextStyle(fontSize: 11),
                          labelText: '최소 쉬는시간',
                        ),
                        validator: (value) {
                          if (!RegExp(r'^([0-5]?\d):([0-5]\d)$')
                              .hasMatch(value!)) {
                            return '올바른 분:초 형식을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Text(' ~ '),
                    Expanded(
                      child: TextFormField(
                        onSaved: (value) => maxBreakTime = value!,
                        decoration: const InputDecoration(
                            hintText: 'ex) 11:11',
                            labelStyle: TextStyle(fontSize: 11),
                            labelText: '최대 쉬는시간'),
                        validator: (value) {
                          if (!RegExp(r'^([0-5]?\d):([0-5]\d)$')
                              .hasMatch(value!)) {
                            return '올바른 분:초 형식을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
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
                    color: const Color(0xFFE7E7E7),
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
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    (_isStudying && !_isPause) || (!_isStudying && _isPause)
                        ? CustomButton(onPressed: null, text: '시작')
                        : CustomButton(onPressed: () => _start(), text: '시작'),
                    !_isStudying && !_isPause
                        ? CustomButton(onPressed: null, text: '쉬는시간 시작')
                        : CustomButton(
                            onPressed: () => _startBreakTime(),
                            text: '쉬는시간 시작'),
                    !_isPause
                        ? CustomButton(onPressed: () => _stop(), text: '일시정지')
                        : CustomButton(onPressed: null, text: '정지'),
                  ],
                ),
                _studyAndBreakTime.isNotEmpty
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restart_alt), label: '재입력'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: '타이머'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이')
        ],
      ),
    );
  }
}
