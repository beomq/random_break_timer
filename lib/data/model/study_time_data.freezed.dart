// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_time_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

StudyTimeData _$StudyTimeDataFromJson(Map<String, dynamic> json) {
  return _StudyTimeData.fromJson(json);
}

/// @nodoc
mixin _$StudyTimeData {
  String get studyTime => throw _privateConstructorUsedError;
  String get minBreakTime => throw _privateConstructorUsedError;
  String get maxBreakTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StudyTimeDataCopyWith<StudyTimeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudyTimeDataCopyWith<$Res> {
  factory $StudyTimeDataCopyWith(
          StudyTimeData value, $Res Function(StudyTimeData) then) =
      _$StudyTimeDataCopyWithImpl<$Res, StudyTimeData>;
  @useResult
  $Res call({String studyTime, String minBreakTime, String maxBreakTime});
}

/// @nodoc
class _$StudyTimeDataCopyWithImpl<$Res, $Val extends StudyTimeData>
    implements $StudyTimeDataCopyWith<$Res> {
  _$StudyTimeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studyTime = null,
    Object? minBreakTime = null,
    Object? maxBreakTime = null,
  }) {
    return _then(_value.copyWith(
      studyTime: null == studyTime
          ? _value.studyTime
          : studyTime // ignore: cast_nullable_to_non_nullable
              as String,
      minBreakTime: null == minBreakTime
          ? _value.minBreakTime
          : minBreakTime // ignore: cast_nullable_to_non_nullable
              as String,
      maxBreakTime: null == maxBreakTime
          ? _value.maxBreakTime
          : maxBreakTime // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_StudyTimeDataCopyWith<$Res>
    implements $StudyTimeDataCopyWith<$Res> {
  factory _$$_StudyTimeDataCopyWith(
          _$_StudyTimeData value, $Res Function(_$_StudyTimeData) then) =
      __$$_StudyTimeDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String studyTime, String minBreakTime, String maxBreakTime});
}

/// @nodoc
class __$$_StudyTimeDataCopyWithImpl<$Res>
    extends _$StudyTimeDataCopyWithImpl<$Res, _$_StudyTimeData>
    implements _$$_StudyTimeDataCopyWith<$Res> {
  __$$_StudyTimeDataCopyWithImpl(
      _$_StudyTimeData _value, $Res Function(_$_StudyTimeData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studyTime = null,
    Object? minBreakTime = null,
    Object? maxBreakTime = null,
  }) {
    return _then(_$_StudyTimeData(
      studyTime: null == studyTime
          ? _value.studyTime
          : studyTime // ignore: cast_nullable_to_non_nullable
              as String,
      minBreakTime: null == minBreakTime
          ? _value.minBreakTime
          : minBreakTime // ignore: cast_nullable_to_non_nullable
              as String,
      maxBreakTime: null == maxBreakTime
          ? _value.maxBreakTime
          : maxBreakTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_StudyTimeData with DiagnosticableTreeMixin implements _StudyTimeData {
  const _$_StudyTimeData(
      {this.studyTime = '', this.minBreakTime = '', this.maxBreakTime = ''});

  factory _$_StudyTimeData.fromJson(Map<String, dynamic> json) =>
      _$$_StudyTimeDataFromJson(json);

  @override
  @JsonKey()
  final String studyTime;
  @override
  @JsonKey()
  final String minBreakTime;
  @override
  @JsonKey()
  final String maxBreakTime;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'StudyTimeData(studyTime: $studyTime, minBreakTime: $minBreakTime, maxBreakTime: $maxBreakTime)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'StudyTimeData'))
      ..add(DiagnosticsProperty('studyTime', studyTime))
      ..add(DiagnosticsProperty('minBreakTime', minBreakTime))
      ..add(DiagnosticsProperty('maxBreakTime', maxBreakTime));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StudyTimeData &&
            (identical(other.studyTime, studyTime) ||
                other.studyTime == studyTime) &&
            (identical(other.minBreakTime, minBreakTime) ||
                other.minBreakTime == minBreakTime) &&
            (identical(other.maxBreakTime, maxBreakTime) ||
                other.maxBreakTime == maxBreakTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, studyTime, minBreakTime, maxBreakTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StudyTimeDataCopyWith<_$_StudyTimeData> get copyWith =>
      __$$_StudyTimeDataCopyWithImpl<_$_StudyTimeData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_StudyTimeDataToJson(
      this,
    );
  }
}

abstract class _StudyTimeData implements StudyTimeData {
  const factory _StudyTimeData(
      {final String studyTime,
      final String minBreakTime,
      final String maxBreakTime}) = _$_StudyTimeData;

  factory _StudyTimeData.fromJson(Map<String, dynamic> json) =
      _$_StudyTimeData.fromJson;

  @override
  String get studyTime;
  @override
  String get minBreakTime;
  @override
  String get maxBreakTime;
  @override
  @JsonKey(ignore: true)
  _$$_StudyTimeDataCopyWith<_$_StudyTimeData> get copyWith =>
      throw _privateConstructorUsedError;
}
