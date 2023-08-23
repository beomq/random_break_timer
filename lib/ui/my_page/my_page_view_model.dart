import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_break_timer/data/model/study_data.dart';
import 'package:random_break_timer/main.dart';

class MyPageViewModel {
  Future<List<StudyData>> getCachedStudyData() async {
    var data = await Hive.box<StudyData>(getUserUid());
    return data.values.toList();
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void allDelete() async {
    var box = await Hive.box<StudyData>(getUserUid());
    await box.clear();
  }

  void deleteItemAtIndex(int index) async {
    var box = await Hive.box<StudyData>(getUserUid());
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
}
