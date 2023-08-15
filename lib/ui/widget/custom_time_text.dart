import 'package:flutter/material.dart';

class CustomTimeText extends StatelessWidget {
  final Duration time;
  const CustomTimeText({
    Key? key,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return time.inHours > 0
        ? Text(
            '${time.inHours} : ${time.inMinutes.remainder(60)} : ${time.inSeconds.remainder(60)} ',
            style: TextStyle(fontSize: 30),
          )
        : Text(
            '${time.inMinutes.remainder(60)} : ${time.inSeconds.remainder(60)} ',
            style: TextStyle(fontSize: 30));
  }
}
