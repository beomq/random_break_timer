import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

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
  Duration _elapsedTime = Duration.zero;
  bool _isStudying = false;
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
    _isStudying = true;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_time != Duration.zero) {
          setState(() {
            _time -= const Duration(seconds: 1);
            _elapsedTime += const Duration(seconds: 1);
          });
        }
      },
    );
  }

  void _stop() {
    _timer?.cancel();
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
    _studyAndBreakTime.add(_elapsedTime);
    _elapsedTime = Duration.zero;
    _isStudying = false;
    _breakTime = getRandomDuration(_minBreakTime, _maxBreakTime);
    _studyAndBreakTime.add(_breakTime);
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_breakTime != Duration.zero) {
          setState(
            () {
              _breakTime -= const Duration(seconds: 1);
            },
          );
        } else {
          _stop();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Timer"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isStudying
                ? Text(
                    '${_time.inHours} : ${_time.inMinutes.remainder(60)} : ${_time.inSeconds.remainder(60)} ')
                : Text(
                    '${_breakTime.inMinutes.remainder(60)} : ${_breakTime.inSeconds.remainder(60)} '),
            ElevatedButton(
              onPressed: () => _showModal(context),
              child: const Text('시간 재설정 하기'),
            ),
            !_isStudying
                ? ElevatedButton(
                    onPressed: () => _start(),
                    child: const Text('시작'),
                  )
                : const ElevatedButton(
                    onPressed: null,
                    child: Text('시작'),
                  ),
            _isStudying
                ? ElevatedButton(
                    onPressed: () => _startBreakTime(),
                    child: const Text('쉬는시간 시작'),
                  )
                : const ElevatedButton(
                    onPressed: null,
                    child: Text('쉬는시간 시작'),
                  ),
            _isStudying
                ? ElevatedButton(
                    onPressed: () => _stop(), child: const Text('정지'))
                : ElevatedButton(onPressed: null, child: Text('정지')),
            Text(durationToString(widget.totalStudyTime +
                const Duration(seconds: 1, minutes: 5))),
            Text(widget.minBreakTime.toString()),
            Text(widget.maxBreakTime.toString()),
            Text('${_studyAndBreakTime.toString()}'),
          ],
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
