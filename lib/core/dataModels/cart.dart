import 'package:flutter/foundation.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/models/order_item.dart';
import 'package:refresco/core/models/payment_method.dart';
import 'package:refresco/core/models/store.dart';

/// TODO:
/// Save cart locally after every change, so state is persisted after restarts.
class Cart {
  final Store store;
  final Set<OrderItem> orderItems;
  final PaymentMethod paymentMethod;

  Cart({
    @required this.orderItems,
    @required this.store,
    @required this.paymentMethod,
  });

  factory Cart.empty({PaymentMethod paymentMethod}) {
    return Cart(
      orderItems: <OrderItem>{},
      store: null,
      paymentMethod: paymentMethod,
    );
  }

  Cart setPaymentMethod(PaymentMethod paymentMethod) {
    return Cart(
      store: store,
      orderItems: orderItems,
      paymentMethod: paymentMethod,
    );
  }

  Cart add(Gallon gallon, Store store) {
    var _orderItem = orderItems.firstWhere(
      (item) => item.product.id == gallon.id,
      orElse: () => null,
    );

    if (_orderItem == null) {
      _orderItem = OrderItem(
        product: gallon,
        amount: 1,
      );
    } else {
      orderItems.remove(_orderItem);

      _orderItem = OrderItem(
        product: _orderItem.product,
        amount: _orderItem.amount + 1,
      );
    }

    return Cart(
      store: store,
      paymentMethod: paymentMethod,
      orderItems: Set.from(
        orderItems..add(_orderItem),
      ),
    );
  }

  bool get isValid {
    if (orderItems.isEmpty) {
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
    return orderItems.fold(0, (previousValue, orderItem) {
      return previousValue + orderItem.amount;
    });
  }

  int get totalPrice {
    return orderItems.fold(0, (previousValue, orderItem) {
      return previousValue + (orderItem.product.price * orderItem.amount);
    });
  }

  String get priceDecimals {
    return (totalPrice / 100).toStringAsFixed(2).split('.').last;
  }

  String get priceIntegers {
    return (totalPrice / 100).toStringAsFixed(2).split('.').first;
  }
}
