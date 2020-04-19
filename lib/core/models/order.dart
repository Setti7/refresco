import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/order_item.dart';
import 'package:refresco/core/models/payment_method.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/models/user.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order {
  @JsonKey(name: 'objectId')
  final String id;

  final Set<OrderItem> orderItems;
  final OrderStatus orderStatus;
  final Store store;
  final User buyer;
  final Address address;
  final PaymentMethod paymentMethod;

  const Order({
    this.id,
    this.orderItems,
    this.orderStatus,
    this.store,
    this.buyer,
    this.address,
    this.paymentMethod,
  });

  factory Order.create({
    @required Cart cart,
    @required User buyer,
    @required Address address,
  }) {
    return Order(
      orderItems: cart.orderItems,
      orderStatus: OrderStatus.pending,
      store: cart.store,
      buyer: buyer,
      address: address,
      paymentMethod: cart.paymentMethod,
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
