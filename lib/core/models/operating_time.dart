import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'time.dart';

part 'generated/operating_time.g.dart';

@JsonSerializable(explicitToJson: true)
class OperatingTime {
  final Time opening;
  final Time closing;

  const OperatingTime({@required this.opening, @required this.closing});

  factory OperatingTime.fromJson(Map<String, dynamic> json) =>
      _$OperatingTimeFromJson(json);

  Map<String, dynamic> toJson() => _$OperatingTimeToJson(this);

}
