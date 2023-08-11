import 'dart:async';

import 'package:flutter/material.dart';

class Ttt extends StatefulWidget {
  const Ttt({Key? key}) : super(key: key);

  @override
  State<Ttt> createState() => _TttState();
}

class _TttState extends State<Ttt> {
  Timer? _timer;
  int _time = 0;
  bool _isStudying = false;
  List<String> _studyAndBreakTime = [];

  void _clickBreakButton() {
    _isStudying = !_isStudying;
    _studyAndBreakTime.add(_time.toString());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                _isStudying
                    ? const Text('Study Timer')
                    : const Text('Break Timer'),
                const Text('data'),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('START BREAK'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('STOP STUDY'),
              ),
            ],
          ),
          const Text('Today Study Time'),
          Container(
            child: const Text('a'),
          )
        ],
      ),
    );
  }
}
