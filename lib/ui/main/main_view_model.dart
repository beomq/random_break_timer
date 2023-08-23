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
    int milliseconds = 0;
    if (parts.length > 1) {
      milliseconds = int.parse(parts[1]);
    }
    List<String> timeParts = parts[0].split(':');
    int hours = 0, minutes = 0, seconds = 0;

    // 시:분:초 형태
    if (timeParts.length == 3) {
      hours = int.parse(timeParts[0]);
      minutes = int.parse(timeParts[1]);
      seconds = int.parse(timeParts[2]);
    }
    // 분:초 형태
    else if (timeParts.length == 2) {
      minutes = int.parse(timeParts[0]);
      seconds = int.parse(timeParts[1]);
    }
    // 초 형태
    else if (timeParts.length == 1) {
      seconds = int.parse(timeParts[0]);
    }

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
    );
  }

  String durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String threeDigitMilliseconds =
        duration.inMilliseconds.remainder(1000).toString().padLeft(3, "0");
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds.$threeDigitMilliseconds";
  }

  Future<void> saveStudyData(StudyData data) async {
    final box = await Hive.openBox<StudyData>(getUserUid());
    final existingData = box.values.where((item) => item.date == data.date);

    if (existingData.isNotEmpty) {
      box.add(data);
    } else {
      final oldData = existingData.first;
      final oldDataKey = box.keyAt(box.values.toList().indexOf(oldData));

      oldData.totalStudyTime = durationToString(
          stringToDuration(oldData.totalStudyTime) +
              stringToDuration(data.totalStudyTime));
      oldData.targetedStudyTime = durationToString(
          stringToDuration(oldData.targetedStudyTime) +
              stringToDuration(data.targetedStudyTime));
      oldData.totalBreakTime = durationToString(
          stringToDuration(oldData.totalBreakTime) +
              stringToDuration(data.totalBreakTime));

      oldData.StudyAndBreakTime.addAll(data.StudyAndBreakTime);
      box.put(oldDataKey, oldData);
    }
  }
}
