import 'package:flutter/material.dart';
import 'package:random_break_timer/main.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('a'),
          ListView(
            shrinkWrap: true,
            children: datas.values
                .map((data) =>
                    ListTile(title: Text(data.totalStudyTime.toString())))
                .toList(),
          ),
        ],
      ),
    );
  }
}
