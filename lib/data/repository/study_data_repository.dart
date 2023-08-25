import 'package:random_break_timer/data/model/study_data.dart';

abstract interface class StudyDataRepository {
  Future<List<StudyData>> getPhotos(String query);
}
