import 'package:flutter/foundation.dart';
import 'package:refresco/core/models/gallon.dart';

@immutable
class Cart {
  final List<Gallon> products;

  Cart(this.products);

  factory Cart.empty() => Cart([]);

  Cart add(Gallon gallon) {
    return Cart(products..add(gallon));
  }
}
