import 'package:json_annotation/json_annotation.dart';

part 'generated/time.g.dart';

@JsonSerializable()
class Time {
  final int hour;
  final int minute;

  const Time(this.hour, [this.minute = 0]);

  factory Time.fromJson(Map<String, dynamic> json) => _$TimeFromJson(json);

  Map<String, dynamic> toJson() => _$TimeToJson(this);
}
