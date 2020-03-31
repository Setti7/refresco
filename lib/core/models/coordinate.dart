import 'package:json_annotation/json_annotation.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'generated/coordinate.g.dart';

@JsonSerializable(nullable: false)
class Coordinate {
  const Coordinate(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  factory Coordinate.fromJson(dynamic json) => _$CoordinateFromJson(json);

  factory Coordinate.fromParse(ParseGeoPoint geoPoint) {
    return Coordinate(geoPoint.latitude, geoPoint.longitude);
  }

  static ParseGeoPoint toParse(Coordinate coordinate) {
    return ParseGeoPoint(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude,
    );
  }

  Map<String, dynamic> toJson() => _$CoordinateToJson(this);
}
