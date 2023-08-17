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
            '${time.inHours.toString().padLeft(2, '0')} : ${time.inMinutes.remainder(60).toString().padLeft(2, '0')} : ${time.inSeconds.remainder(60).toString().padLeft(2, '0')} ',
            style: TextStyle(fontSize: 40),
          )
        : Text(
            '${time.inMinutes.remainder(60).toString().padLeft(2, '0')} : ${time.inSeconds.remainder(60).toString().padLeft(2, '0')} ',
            style: TextStyle(fontSize: 40));
  }
}
