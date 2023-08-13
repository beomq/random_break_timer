import 'package:hive/hive.dart';
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
  List<String> StudyAndBreakTime;

  StudyData({
    required this.date,
    required this.totalStudyTime,
    required this.targetedStudyTime,
    required this.totalBreakTime,
    required this.StudyAndBreakTime,
  });
}
