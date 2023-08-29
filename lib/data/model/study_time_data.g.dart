// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_time_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_StudyTimeData _$$_StudyTimeDataFromJson(Map<String, dynamic> json) =>
    _$_StudyTimeData(
      studyTime: json['studyTime'] as String? ?? '',
      minBreakTime: json['minBreakTime'] as String? ?? '',
      maxBreakTime: json['maxBreakTime'] as String? ?? '',
    );

Map<String, dynamic> _$$_StudyTimeDataToJson(_$_StudyTimeData instance) =>
    <String, dynamic>{
      'studyTime': instance.studyTime,
      'minBreakTime': instance.minBreakTime,
      'maxBreakTime': instance.maxBreakTime,
    };
