import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'study_time_data.freezed.dart';

part 'study_time_data.g.dart';

@freezed
class StudyTimeData with _$StudyTimeData {
  const factory StudyTimeData({
    String studyTime,
    String minBreakTime,
    String maxBreakTime,
  }) = _StudyTimeData;

  factory StudyTimeData.fromJson(Map<String, Object?> json) =>
      _$StudyTimeDataFromJson(json);
}
