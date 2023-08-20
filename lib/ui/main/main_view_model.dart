import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_break_timer/data/model/study_data.dart';

class MainViewModel {
  bool isPause = false;
  bool isStudying = false;
  Timer? timer;
  Duration time = Duration(seconds: 1);
  Duration elapsedTime = Duration(seconds: 1);

  void start() {
    isPause = false;
    isStudying = true;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (time != Duration.zero) {
          time -= const Duration(seconds: 1);
          elapsedTime += const Duration(seconds: 1);
        }
      },
    );
  }

  String getUserUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Duration stringToDuration(String input) {
    List<String> parts = input.split('.');
    int milliseconds = int.parse(parts[1]);
    List<String> timeParts = parts[0].split(':');
    return Duration(
      hours: int.parse(timeParts[0]),
      minutes: int.parse(timeParts[1]),
      seconds: int.parse(timeParts[2]),
      milliseconds: milliseconds,
    );
  }

  Future<void> saveStudyData(StudyData data) async {
    final box = await Hive.openBox<StudyData>(getUserUid());
    final existingData = box.values.where((item) => item.date == data.date);

    if (existingData.isEmpty) {
      box.add(data);
    } else {
      final oldData = existingData.first;
      final oldDataKey = box.keyAt(box.values.toList().indexOf(oldData));

      oldData.totalStudyTime = (stringToDuration(oldData.totalStudyTime) +
              stringToDuration(data.totalStudyTime))
          .toString();
      oldData.targetedStudyTime = (stringToDuration(oldData.targetedStudyTime) +
              stringToDuration(data.targetedStudyTime))
          .toString();
      oldData.totalBreakTime = (stringToDuration(oldData.totalBreakTime) +
              stringToDuration(data.totalBreakTime))
          .toString();

      oldData.StudyAndBreakTime.addAll(data.StudyAndBreakTime);
      box.put(oldDataKey, oldData);
    }
  }
}
