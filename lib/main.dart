import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_break_timer/data/model/study_data.dart';
import 'package:random_break_timer/ui/auth/auth_gate.dart';
import 'package:random_break_timer/ui/loading/loading_screen.dart';

late final Box<StudyData> datas;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(StudyDataAdapter());
  datas = await Hive.openBox<StudyData>('todolist.db');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loading Screen Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoadingScreen(),
    );
  }
}
