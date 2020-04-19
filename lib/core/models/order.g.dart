// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map json) {
  return Order(
    id: json['objectId'] as String,
    orderItems: (json['orderItems'] as List)
        ?.map((e) => e == null
            ? null
            : OrderItem.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toSet(),
    orderStatus:
        _$enumDecodeNullable(_$OrderStatusEnumMap, json['orderStatus']),
    store: json['store'] == null
        ? null
        : Store.fromJson((json['store'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    buyer: json['buyer'] == null
        ? null
        : User.fromJson((json['buyer'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    address: json['address'] == null
        ? null
        : Address.fromJson((json['address'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    paymentMethod: json['paymentMethod'] == null
        ? null
        : PaymentMethod.fromJson((json['paymentMethod'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'objectId': instance.id,
      'orderItems': instance.orderItems?.map((e) => e?.toJson())?.toList(),
      'orderStatus': _$OrderStatusEnumMap[instance.orderStatus],
      'store': instance.store?.toJson(),
      'buyer': instance.buyer?.toJson(),
      'address': instance.address?.toJson(),
      'paymentMethod': instance.paymentMethod?.toJson(),
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

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
};
