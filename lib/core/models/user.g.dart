// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map json) {
  return User(
    id: json['objectId'] as String,
    fullName: json['fullName'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    cpf: json['cpf'] as String,
    address: json['address'] == null
        ? null
        : Address.fromJson((json['address'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'objectId': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'cpf': instance.cpf,
      'address': instance.address?.toJson(),
    };
