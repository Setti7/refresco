// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as String,
    fullName: json['fullName'] as String,
    email: json['email'] as String,
    userAddress: json['userAddress'] == null
        ? null
        : UserAddress.fromJson(json['userAddress'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'userAddress': instance.userAddress?.toJson(),
    };
