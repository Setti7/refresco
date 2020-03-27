import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coordinate.g.dart';

// TODO: missing geohash
@JsonSerializable(nullable: false)
class Coordinate {
  const Coordinate(this.latitude, this.longitude, [this.geoHash]);

  final String geoHash;
  final double latitude;
  final double longitude;

  @override
  bool operator ==(dynamic o) =>
      o is Coordinate && o.latitude == latitude && o.longitude == longitude;

  @override
  int get hashCode => hashValues(latitude, longitude);

  factory Coordinate.fromJson(dynamic json) {
    if (json is GeoPoint) {
      return Coordinate.fromGeoPoint(json);
    }

    return _$CoordinateFromJson(json);
  }

  factory Coordinate.fromGeoPoint(GeoPoint geoPoint) {
    return Coordinate(geoPoint.longitude, geoPoint.longitude);
  }

  Map<String, dynamic> toJson() => _$CoordinateToJson(this);
}
