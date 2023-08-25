import 'package:random_break_timer/data/model/study_data.dart';

extension ToPhoto on StudyData {
  StudyData toPhoto() {
    return StudyData(
      date: date ?? '',
      totalStudyTime: totalStudyTime ?? '',
      targetedStudyTime: targetedStudyTime ?? '',
      totalBreakTime: totalBreakTime ?? '',
      studyAndBreakTime: studyAndBreakTime,
    );
  }
}
