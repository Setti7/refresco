// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coordinate _$CoordinateFromJson(Map json) {
  return Coordinate(
    (json['latitude'] as num).toDouble(),
    (json['longitude'] as num).toDouble(),
    json['geoHash'] as String,
  );
}

Map<String, dynamic> _$CoordinateToJson(Coordinate instance) =>
    <String, dynamic>{
      'geoHash': instance.geoHash,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
