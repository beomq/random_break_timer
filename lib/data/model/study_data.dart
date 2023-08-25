import 'package:hive_flutter/hive_flutter.dart';
part 'study_data.g.dart';

@HiveType(typeId: 0)
class StudyData extends HiveObject {
  @HiveField(0)
  String date;

  @HiveField(1)
  String totalStudyTime;

  @HiveField(2)
  String targetedStudyTime;

  @HiveField(3)
  String totalBreakTime;

  @HiveField(4)
  List<Duration> studyAndBreakTime;

  StudyData({
    required this.date,
    required this.totalStudyTime,
    required this.targetedStudyTime,
    required this.totalBreakTime,
    required this.studyAndBreakTime,
  });
}
