// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gallon _$GallonFromJson(Map json) {
  return Gallon(
    type: _$enumDecode(_$GallonTypeEnumMap, json['type']),
    price: (json['price'] as num).toDouble(),
    company: json['company'] as String,
  );
}

Map<String, dynamic> _$GallonToJson(Gallon instance) => <String, dynamic>{
      'type': _$GallonTypeEnumMap[instance.type],
      'price': instance.price,
      'company': instance.company,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

const _$GallonTypeEnumMap = {
  GallonType.l20: 'l20',
  GallonType.l10: 'l10',
};
