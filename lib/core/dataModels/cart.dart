import 'package:flutter/foundation.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/models/order_item.dart';
import 'package:refresco/core/models/payment_method.dart';
import 'package:refresco/core/models/store.dart';

class Cart {
  final Store store;
  final Set<OrderItem> products;
  final PaymentMethod paymentMethod;
  /// TODO:
  /// Remove address from user and set it here, then, change the auth service
  /// to always upload the user when it changes (remove the uploadUser method
  /// and put its logic inside the updateUser).

  Cart({
    @required this.products,
    @required this.store,
    @required this.paymentMethod,
  });

  factory Cart.empty({PaymentMethod paymentMethod}) {
    return Cart(
      products: <OrderItem>{},
      store: null,
      paymentMethod: paymentMethod,
    );
  }

  Cart setPaymentMethod(PaymentMethod paymentMethod) {
    return Cart(
      store: store,
      products: products,
      paymentMethod: paymentMethod,
    );
  }

  Cart add(Gallon gallon, Store store) {
    var cartItem = products.firstWhere(
      (item) => item.product.id == gallon.id,
      orElse: () => null,
    );

    if (cartItem == null) {
      cartItem = OrderItem(
        product: gallon,
        amount: 1,
      );
    } else {
      products.remove(cartItem);

      cartItem = OrderItem(
        product: cartItem.product,
        amount: cartItem.amount + 1,
      );
    }

    return Cart(
      store: store,
      paymentMethod: paymentMethod,
      products: Set.from(
        products..add(cartItem),
      ),
    );
  }

  bool get isValid {
    if (products.isEmpty) {
      return false;
    } else if (paymentMethod == null) {
      return false;
    } else if (paymentMethod.change != null &&
        paymentMethod.change < totalPrice) {
      return false;
    }
    return true;
  }

  int get totalItemAmount {
    return products.fold(0, (previousValue, cartItem) {
      return previousValue + cartItem.amount;
    });
  }

  int get totalPrice {
    return products.fold(0, (previousValue, cartItem) {
      return previousValue + (cartItem.product.price * cartItem.amount);
    });
  }

  String get priceDecimals {
    return (totalPrice / 100).toStringAsFixed(2).split('.').last;
  }

  String get priceIntegers {
    return (totalPrice / 100).toStringAsFixed(2).split('.').first;
  }
}
