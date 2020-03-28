// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../operating_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperatingTime _$OperatingTimeFromJson(Map json) {
  return OperatingTime(
    opening: json['opening'] == null
        ? null
        : Time.fromJson((json['opening'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    closing: json['closing'] == null
        ? null
        : Time.fromJson((json['closing'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
  );
}

Map<String, dynamic> _$OperatingTimeToJson(OperatingTime instance) =>
    <String, dynamic>{
      'opening': instance.opening?.toJson(),
      'closing': instance.closing?.toJson(),
    };
