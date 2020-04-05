import 'package:flutter/foundation.dart';
import 'package:refresco/core/dataModels/cart_item.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/models/store.dart';

// TODO:
//  change this to Order class and add a filed called cart which is a list of
//  products
@immutable
class Cart {
  final Store store;
  final Set<CartItem> products;

  Cart({
    @required this.products,
    @required this.store,
  });

  factory Cart.empty() {
    return Cart(
      products: <CartItem>{},
      store: null,
    );
  }

  Cart add(Gallon gallon, Store store) {
    var cartItem = products.firstWhere(
      (item) => item.product.id == gallon.id,
      orElse: () => null,
    );

    if (cartItem == null) {
      cartItem = CartItem(
        product: gallon,
        amount: 1,
      );
    } else {
      products.remove(cartItem);

      cartItem = CartItem(
        product: cartItem.product,
        amount: cartItem.amount + 1,
      );
    }

    return Cart(
      store: store,
      products: Set.from(
        products..add(cartItem),
      ),
    );
  }

  int get totalItemAmount {
    return products.fold(0, (previousValue, cartItem) {
      return previousValue + cartItem.amount;
    });
  }

  int get _totalPrice {
    return products.fold(0, (previousValue, cartItem) {
      return previousValue + (cartItem.product.price * cartItem.amount);
    });
  }

  String get priceDecimals {
    return (_totalPrice / 100).toStringAsFixed(2).split('.').last;
  }

  String get priceIntegers {
    return (_totalPrice / 100).toStringAsFixed(2).split('.').first;
  }
}
