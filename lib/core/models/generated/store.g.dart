// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map json) {
  return Store(
    name: json['name'] as String,
    id: json['id'] as String,
    description: json['description'] as String,
    rating: (json['rating'] as num)?.toDouble(),
    minDeliveryTime: json['minDeliveryTime'] as int,
    maxDeliveryTime: json['maxDeliveryTime'] as int,
    phone: json['phone'] as int,
    operatingTime: json['operatingTime'] == null
        ? null
        : OperatingTime.fromJson((json['operatingTime'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    address: json['address'] == null
        ? null
        : Address.fromJson((json['address'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
  );
}

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'rating': instance.rating,
      'minDeliveryTime': instance.minDeliveryTime,
      'maxDeliveryTime': instance.maxDeliveryTime,
      'phone': instance.phone,
      'operatingTime': instance.operatingTime?.toJson(),
      'address': instance.address?.toJson(),
    };
