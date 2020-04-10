// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethod _$PaymentMethodFromJson(Map json) {
  return PaymentMethod(
    id: json['objectId'] as String,
    name: json['name'] as String,
    imageUri: json['imageUri'] as String,
    type: _$enumDecodeNullable(_$CardTypeEnumMap, json['type']),
    change: json['change'] as int,
  );
}

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'objectId': instance.id,
      'name': instance.name,
      'type': _$CardTypeEnumMap[instance.type],
      'imageUri': instance.imageUri,
      'change': instance.change,
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

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$CardTypeEnumMap = {
  CardType.credit: 'credit',
  CardType.debit: 'debit',
};
