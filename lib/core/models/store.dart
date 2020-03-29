import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/core/models/address.dart';
import 'package:flutter_base/core/models/gallon.dart';
import 'package:flutter_base/core/models/operating_time.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'generated/store.g.dart';

@JsonSerializable(explicitToJson: true)
class Store {
  final String id;
  final String name;
  final String description;
  final double rating;
  final int minDeliveryTime;
  final int maxDeliveryTime;
  final int phone;
  final OperatingTime operatingTime;
  final Address address;
  final List<Gallon> gallons;

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
    this.gallons,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  factory Store.fromParse(ParseObject store) {
    // TODO finish
    return Store(
      id: store.objectId,
      name: store.get<String>('name'),
      description: store.get<String>('description'),
      rating: store.get<num>('rating')?.toDouble(),
      phone: store.get<int>('phone'),
      maxDeliveryTime: 15,
      minDeliveryTime: 10,
      address: Address.fromParse(
        store.get<ParseObject>('address'),
      ),
    );
  }

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
