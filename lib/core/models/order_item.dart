import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:refresco/core/models/gallon.dart';

part 'order_item.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderItem extends Equatable {
  @JsonKey(name: 'objectId')
  final int id;

  final int amount;
  final Gallon product;

  const OrderItem({
    this.id,
    @required this.amount,
    @required this.product,
  });

  @override
  List<Object> get props => [product.id];

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
