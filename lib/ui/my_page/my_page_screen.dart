import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_break_timer/data/model/study_data.dart';
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
  Box<StudyData>? studyDataList;
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
          List.generate(studyDataList!.values.length, (index) => false);
    });
  }

  @override
  void dispose() {
    if (studyDataList != null) {
      studyDataList!.close();
    }
    super.dispose();
  }

  Duration _getTotalStudyTime() {
    Duration totalStudyTime = Duration();
    int length = studyDataList?.length ?? 0;
    for (int i = 0; i < length; i++) {
      var studyData = studyDataList?.getAt(i);
      if (studyData != null) {
        totalStudyTime += model.stringToDuration(studyData.totalStudyTime);
      }
    }
    return totalStudyTime;
  }

  Duration _getTotalTargetedStudyTime() {
    Duration totalTargetedStudyTime = Duration();
    int length = studyDataList?.length ?? 0;
    for (int i = 0; i < length; i++) {
      var studyData = studyDataList?.getAt(i);
      if (studyData != null) {
        totalTargetedStudyTime +=
            model.stringToDuration(studyData.targetedStudyTime);
      }
    }
    return totalTargetedStudyTime;
  }

  void _deleteSelectedItems() {
    setState(() {
      for (int i = studyDataList!.length - 1; i >= 0; i--) {
        model.allDelete();
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
                    iconData: Icons.note_outlined,
                    resultText: _getTotalStudyTime().toString().split('.')[0],
                    detailText: '총 공부 시간'),
                CustomRecordedContainer(
                    iconData: Icons.emoji_events_outlined,
                    resultText:
                        '${(_getTotalStudyTime().inSeconds / _getTotalTargetedStudyTime().inSeconds * 100).toStringAsFixed(2)} %',
                    detailText: '총 목표 달성율'),
                CustomRecordedContainer(
                    iconData: Icons.hotel_class_outlined,
                    resultText: '${studyDataList?.length ?? 0}일',
                    detailText: '공부 시작한지'),
              ],
            ),
          ),
          Text('지난날의 기록'),
          Expanded(
            child: ListView.builder(
              itemCount: studyDataList?.length ?? 0,
              itemBuilder: (context, index) {
                StudyData studyData = studyDataList!.getAt(index)!;

                Duration targetedDuration =
                    model.stringToDuration(studyData.targetedStudyTime);
                Duration totalDuration =
                    model.stringToDuration(studyData.totalStudyTime);
                double achievementRate =
                    totalDuration.inSeconds / targetedDuration.inSeconds * 100;
                return Dismissible(
                  key: Key(studyData.date.toString()),
                  onDismissed: (direction) {
                    // 삭제 로직

                    model.deleteItemAtIndex(index);
                    // 스낵바 메시지
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('항목이 삭제되었습니다.')));
                    setState(() {});
                  },
                  background: Container(
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ExpansionTile(
                    title: Text(model.formatDate(studyData.date)),
                    children: [
                      ListTile(
                        title: Text(
                            '목표 공부 시간: ${model.formatTime(studyData.targetedStudyTime.toString())}'),
                      ),
                      ListTile(
                        title: Text(
                            '총 공부 시간: ${model.formatTime(studyData.totalStudyTime.toString())}'),
                      ),
                      ListTile(
                        title: Text(
                            '총 쉬는 시간: ${model.formatTime(studyData.totalBreakTime.toString())}'),
                      ),
                      ListTile(
                        title: Text(
                            '목표 달성률: ${achievementRate.toStringAsFixed(2)}%'),
                      ),
                      ExpansionTile(
                        title: const Text('Study and Break Time'),
                        children: List<Widget>.generate(
                            studyData.StudyAndBreakTime.length ~/ 2,
                            (int index) {
                          Duration studyDuration =
                              studyData.StudyAndBreakTime[index * 2];
                          Duration breakDuration =
                              studyData.StudyAndBreakTime[index * 2 + 1];
                          return ListTile(
                            title: Text(
                              '${index + 1}. 공부 시간: ${model.formatDuration(studyDuration)} 쉬는 시간: ${model.formatDuration(breakDuration)}',
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
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
