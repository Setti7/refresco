import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/operating_time.dart';

part 'store.g.dart';

@JsonSerializable(explicitToJson: true)
class Store {
  @JsonKey(name: 'objectId')
  final String id;
  final String name;
  final String description;
  final double rating;
  final int minDeliveryTime;
  final int maxDeliveryTime;
  final int phone;
  final OperatingTime operatingTime;
  final Address address;

  const Store({
    this.name,
    this.id,
    this.description,
    this.rating,
    this.minDeliveryTime,
    this.maxDeliveryTime,
    this.phone,
    this.operatingTime,
    this.address,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  Map<String, dynamic> toJson() => _$StoreToJson(this);

  IconData getStarIcon() {
    if (rating == null) {
      return Icons.new_releases;
    }

    if (rating >= 4.0) {
      return Icons.star;
    } else if (rating >= 3.0) {
      return Icons.star_half;
    } else {
      return Icons.star_border;
    }
  }
}
