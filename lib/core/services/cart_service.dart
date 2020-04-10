import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/models/payment_method.dart';
import 'package:refresco/core/models/store.dart';
import 'package:rxdart/rxdart.dart';

class CartService {
  // Streams
  Stream<Cart> get cart => _cartSubject.stream;
  final BehaviorSubject<Cart> _cartSubject =
      BehaviorSubject.seeded(Cart.empty());

  bool addToCart(Gallon gallon, Store store) {
    final currentCart = _cartSubject.value;

    if (currentCart.store != null && currentCart.store.id != gallon.store.id) {
      return false;
    }

    _cartSubject.add(currentCart.add(gallon, store));
    return true;
  }

  void clearCart() {
    final currentCart = _cartSubject.value;
    _cartSubject.add(Cart.empty(paymentMethod: currentCart.paymentMethod));
  }

  void setPaymentMethod(PaymentMethod paymentMethod) {
    final currentCart = _cartSubject.value;
    _cartSubject.add(currentCart.setPaymentMethod(paymentMethod));
  }
}
