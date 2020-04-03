import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:refresco/core/models/gallon.dart';

class CartItem extends Equatable {
  final int amount;
  final Gallon product;

  const CartItem({
    @required this.amount,
    @required this.product,
  });

  @override
  List<Object> get props => [product.id];
}
