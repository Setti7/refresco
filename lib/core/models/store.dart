import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:random_string/random_string.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/operating_time.dart';

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

  factory Store.fromParse(ParseObject store) {
    if (store == null) return Store();
    return Store(
      id: store.objectId,
      name: store.get<String>('name'),
      description: store.get<String>('description'),
      rating: store.get<num>('rating')?.toDouble(),
      maxDeliveryTime: 15,
      minDeliveryTime: 10,
      phone: store.get<int>('phone'),
      address: Address.fromParse(store.get<ParseObject>('address')),
    );
  }

  static ParseObject toParse(Store store) {
    return ParseObject('Store')
      ..objectId = store.id ?? randomAlphaNumeric(10)
      ..set('name', store.name)
      ..set('description', store.description)
      ..set('rating', store.rating)
      ..set('phone', store.phone)
      ..set('address', Address.toParse(store.address));
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
