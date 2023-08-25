import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_break_timer/data/model/study_data.dart';
import 'package:intl/intl.dart';

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

    if (existingData.isEmpty) {
      box.add(data);
    } else {
      final oldData = existingData.first;
      final oldDataKey = box.keyAt(box.values.toList().indexOf(oldData));

      oldData.targetedStudyTime = data.targetedStudyTime;
      oldData.totalStudyTime = durationToString(
          stringToDuration(oldData.totalStudyTime) +
              stringToDuration(data.totalStudyTime));
      oldData.totalBreakTime = durationToString(
          stringToDuration(oldData.totalBreakTime) +
              stringToDuration(data.totalBreakTime));

      oldData.studyAndBreakTime.addAll(data.studyAndBreakTime);
      box.put(oldDataKey, oldData);
    }
  }

  Duration getRandomDuration(Duration min, Duration max) {
    final random = Random();
    int range = max.inSeconds - min.inSeconds;

    int randomSeconds = random.nextInt(range + 1);
    return min + Duration(seconds: randomSeconds);
  }

  String formatDuration(Duration duration) {
    String hours = duration.inHours > 0 ? '${duration.inHours}시 ' : '';
    String minutes =
        duration.inMinutes % 60 > 0 ? '${duration.inMinutes % 60}분 ' : '';
    String seconds =
        duration.inSeconds % 60 > 0 ? '${duration.inSeconds % 60}초 ' : '0초';
    return '$hours$minutes$seconds';
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date).toString();
  }
}
