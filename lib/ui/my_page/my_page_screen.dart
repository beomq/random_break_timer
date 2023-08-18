import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_break_timer/data/model/study_data.dart';
import 'package:random_break_timer/main.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  late List<StudyData> studyDataList;

  @override
  void initState() {
    super.initState();
    studyDataList = datas.values.toList();
  }

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  String _formatTime(String timeString) {
    List<String> timeParts = timeString.split(':');
    double hours = double.parse(timeParts[0]);
    double minutes = double.parse(timeParts[1]);
    double seconds = double.parse(timeParts[2]);

    List<String> formattedParts = [];
    if (hours > 0) formattedParts.add('${hours.toInt()}시');
    if (minutes > 0) formattedParts.add('${minutes.toInt()}분');
    if (seconds > 0) formattedParts.add('${seconds.toInt()}초');

    return formattedParts.join(' ');
  }

  String _formatDuration(Duration duration) {
    String hours = duration.inHours > 0 ? '${duration.inHours}시 ' : '';
    String minutes =
        duration.inMinutes % 60 > 0 ? '${duration.inMinutes % 60}분 ' : '';
    String seconds =
        duration.inSeconds % 60 > 0 ? '${duration.inSeconds % 60}초 ' : '';
    return '$hours$minutes$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: studyDataList.length,
      itemBuilder: (context, index) {
        StudyData studyData = studyDataList[index];
        Duration parseDuration(String duration) {
          List<String> parts = duration.split(':');
          return Duration(
            hours: double.parse(parts[0]).toInt(),
            minutes: double.parse(parts[1]).toInt(),
            seconds: double.parse(parts[2]).toInt(),
          );
        }

        Duration targetedDuration = parseDuration(studyData.targetedStudyTime);
        Duration totalDuration = parseDuration(studyData.totalStudyTime);
        double achievementRate =
            totalDuration.inSeconds / targetedDuration.inSeconds * 100;
        return ExpansionTile(
          title: Text(_formatDate(studyData.date)),
          children: [
            ListTile(
              title:
                  Text('목표 공부 시간: ${_formatTime(studyData.targetedStudyTime)}'),
            ),
            ListTile(
              title: Text('총 공부 시간: ${_formatTime(studyData.totalStudyTime)}'),
            ),
            ListTile(
              title: Text('총 쉬는 시간: ${_formatTime(studyData.totalBreakTime)}'),
            ),
            ListTile(
              title: Text('목표 달성률: ${achievementRate.toStringAsFixed(2)}%'),
            ),
            ExpansionTile(
              title: const Text('Study and Break Time'),
              children: List<Widget>.generate(
                  studyData.StudyAndBreakTime.length ~/ 2, (int index) {
                Duration studyDuration = studyData.StudyAndBreakTime[index * 2];
                Duration breakDuration =
                    studyData.StudyAndBreakTime[index * 2 + 1];
                return ListTile(
                  title: Text(
                    '${index + 1}. 공부 시간: ${_formatDuration(studyDuration)} 쉬는 시간: ${_formatDuration(breakDuration)}',
                  ),
                );
              }),
            ),
          ],
        );
      },
    ));
  }
}
