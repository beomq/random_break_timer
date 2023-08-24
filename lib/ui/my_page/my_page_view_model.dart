import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_break_timer/data/model/study_data.dart';
import 'package:intl/intl.dart';

class MyPageViewModel {
  Future<List<StudyData>> getCachedStudyData() async {
    var data = await Hive.box<StudyData>(getUserUid());
    return data.values.toList();
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void allDelete() async {
    var box = Hive.box<StudyData>(getUserUid());
    await box.clear();
  }

  void deleteItemAtIndex(int index) async {
    var box = Hive.box<StudyData>(getUserUid());
    if (index < box.length) {
      await box.deleteAt(index);
    }
  }

  String getNickname() {
    return FirebaseAuth.instance.currentUser?.displayName ?? '이름 없음';
  }

  String getProfileImageUrl() {
    return FirebaseAuth.instance.currentUser?.photoURL ??
        'https://cdn.pixabay.com/photo/2023/06/03/17/11/giraffe-8038107_1280.jpg';
  }

  String getUserUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  String formatTime(String timeString) {
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

  String formatDuration(Duration duration) {
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
}
