import 'package:json_annotation/json_annotation.dart';

part 'coordinate.g.dart';

@JsonSerializable()
class Coordinate {
  const Coordinate(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  bool get isValid {
    if (latitude == null) return false;
    if (longitude == null) return false;
    return true;
  }

  factory Coordinate.fromJson(dynamic json) => _$CoordinateFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinateToJson(this);
}
