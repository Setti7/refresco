// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAddress _$UserAddressFromJson(Map json) {
  return UserAddress(
    streetName: json['streetName'] as String,
    number: json['number'] as int,
    city: json['city'] as String,
    state: json['state'] as String,
    district: json['district'] as String,
    complement: json['complement'] as String,
    country: json['country'] as String,
    pointOfReference: json['pointOfReference'] as String,
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    completeAddress: json['completeAddress'] as String,
    postalCode: json['postalCode'] as String,
  );
}

Map<String, dynamic> _$UserAddressToJson(UserAddress instance) =>
    <String, dynamic>{
      'streetName': instance.streetName,
      'number': instance.number,
      'city': instance.city,
      'state': instance.state,
      'district': instance.district,
      'complement': instance.complement,
      'country': instance.country,
      'pointOfReference': instance.pointOfReference,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'completeAddress': instance.completeAddress,
      'postalCode': instance.postalCode,
    };
