import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:random_break_timer/data/model/study_data.dart';
import 'package:random_break_timer/main.dart';
import 'package:random_break_timer/ui/my_page/my_page_view_model.dart';
import 'package:random_break_timer/ui/widget/custom_button.dart';
import 'package:random_break_timer/ui/widget/custom_recorded_container.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final model = MyPageViewModel();
  late Box<StudyData> studyDataList;
  late List<bool> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    studyDataList = await Hive.openBox<StudyData>(model.getUserUid());
    setState(() {
      _selectedItems =
          List.generate(studyDataList.values.length, (index) => false);
    });
  }

  @override
  void dispose() {
    studyDataList.close();
    super.dispose();
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

  Duration stringToDuration(String durationString) {
    List<String> parts = durationString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2].split('.')[0]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  Duration _getTotalStudyTime() {
    Duration totalStudyTime = Duration();
    for (int i = 0; i < studyDataList.length; i++) {
      totalStudyTime +=
          stringToDuration(studyDataList.getAt(i)!.totalStudyTime);
    }
    return totalStudyTime;
  }

  Duration _getTotalTargetedStudyTime() {
    Duration totalTargetedStudyTime = Duration();
    for (int i = 0; i < studyDataList.length; i++) {
      totalTargetedStudyTime +=
          stringToDuration(studyDataList.getAt(i)!.targetedStudyTime);
    }
    return totalTargetedStudyTime;
  }

  void _toggleSelection(int index) {
    setState(() {
      _selectedItems[index] = !_selectedItems[index];
    });
  }

  void _deleteSelectedItems() {
    setState(() {
      for (int i = studyDataList.length - 1; i >= 0; i--) {
        if (_selectedItems[i]) {
          _selectedItems.removeAt(i);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(model.getProfileImageUrl()),
              ),
              Column(
                children: [
                  Text('Profile'),
                  Text(model.getNickname()),
                ],
              )
            ],
          ),
          Text('Study Recorded'),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomRecordedContainer(
                    iconData: Icons.access_time,
                    resultText: _getTotalStudyTime().toString().split('.')[0],
                    detailText: '총 공부 시간'),
                CustomRecordedContainer(
                    iconData: Icons.access_time,
                    resultText:
                        '${(_getTotalStudyTime().inSeconds / _getTotalTargetedStudyTime().inSeconds * 100).toStringAsFixed(2)} %',
                    detailText: '총 목표 달성율'),
                CustomRecordedContainer(
                    iconData: Icons.access_time,
                    resultText: '${studyDataList.length}일',
                    detailText: '공부 시작한지'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: studyDataList.length,
              itemBuilder: (context, index) {
                StudyData studyData = studyDataList.getAt(index)!;
                Duration parseDuration(String duration) {
                  List<String> parts = duration.split(':');
                  return Duration(
                    hours: double.parse(parts[0]).toInt(),
                    minutes: double.parse(parts[1]).toInt(),
                    seconds: double.parse(parts[2]).toInt(),
                  );
                }

                Duration targetedDuration =
                    stringToDuration(studyData.targetedStudyTime);
                Duration totalDuration =
                    stringToDuration(studyData.totalStudyTime);
                double achievementRate =
                    totalDuration.inSeconds / targetedDuration.inSeconds * 100;
                return ExpansionTile(
                  title: Text(_formatDate(studyData.date)),
                  children: [
                    ListTile(
                      title: Text(
                          '목표 공부 시간: ${_formatTime(studyData.targetedStudyTime.toString())}'),
                    ),
                    ListTile(
                      title: Text(
                          '총 공부 시간: ${_formatTime(studyData.totalStudyTime.toString())}'),
                    ),
                    ListTile(
                      title: Text(
                          '총 쉬는 시간: ${_formatTime(studyData.totalBreakTime.toString())}'),
                    ),
                    ListTile(
                      title: Text(
                          '목표 달성률: ${achievementRate.toStringAsFixed(2)}%'),
                    ),
                    ExpansionTile(
                      title: const Text('Study and Break Time'),
                      children: List<Widget>.generate(
                          studyData.StudyAndBreakTime.length ~/ 2, (int index) {
                        Duration studyDuration =
                            studyData.StudyAndBreakTime[index * 2];
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
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CustomButton(
                  text: '선택 삭제',
                  onPressed: _deleteSelectedItems,
                ),
                CustomButton(
                  text: 'LOGOUT',
                  onPressed: () {
                    model.logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
