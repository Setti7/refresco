import 'package:json_annotation/json_annotation.dart';

part 'coordinate.g.dart';

@JsonSerializable(nullable: false)
class Coordinate {
  const Coordinate(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  factory Coordinate.fromJson(dynamic json) => _$CoordinateFromJson(json);


  Map<String, dynamic> toJson() => _$CoordinateToJson(this);
}
