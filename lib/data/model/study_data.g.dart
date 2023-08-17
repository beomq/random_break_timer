// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudyDataAdapter extends TypeAdapter<StudyData> {
  @override
  final int typeId = 0;

  @override
  StudyData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudyData(
      date: fields[0] as String,
      totalStudyTime: fields[1] as String,
      targetedStudyTime: fields[2] as String,
      totalBreakTime: fields[3] as String,
      StudyAndBreakTime: (fields[4] as List).cast<Duration>(),
    );
  }

  @override
  void write(BinaryWriter writer, StudyData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.totalStudyTime)
      ..writeByte(2)
      ..write(obj.targetedStudyTime)
      ..writeByte(3)
      ..write(obj.totalBreakTime)
      ..writeByte(4)
      ..write(obj.StudyAndBreakTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
