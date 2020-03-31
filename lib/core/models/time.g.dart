// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Time _$TimeFromJson(Map<String, dynamic> json) {
  return Time(
    json['hour'] as int,
    json['minute'] as int,
  );
}

Map<String, dynamic> _$TimeToJson(Time instance) => <String, dynamic>{
      'hour': instance.hour,
      'minute': instance.minute,
    };
