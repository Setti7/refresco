// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map json) {
  return OrderItem(
    id: json['objectId'] as int,
    amount: json['amount'] as int,
    product: json['product'] == null
        ? null
        : Gallon.fromJson((json['product'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
  );
}

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'objectId': instance.id,
      'amount': instance.amount,
      'product': instance.product?.toJson(),
    };
