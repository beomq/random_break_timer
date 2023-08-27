import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:random_break_timer/data/model/study_data.dart';

class LocalDataSource {
  String getUserUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  /// 캐싱한 게시물을 가져온다.
  Future<List<StudyData>> getCachedStudyData() async {
    var data = await Hive.box<StudyData>(getUserUid());
    return data.values.toList();
  }

  /// 기존에 캐싱된 게시물들을 모두 삭제하고 새로운 게시물을 캐싱한다.
  Future<void> updateCachedPosts(List<StudyData> posts) async {
    var postBox = await Hive.box<StudyData>('postBox');
    await postBox.clear();
    await postBox.addAll(posts);
  }
}
