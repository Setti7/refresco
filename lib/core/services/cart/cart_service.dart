import 'package:logger/logger.dart';
import 'package:refresco/core/models/cart.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

class CartService {
  final Logger _logger = getLogger('CartService');

  // Streams
  Observable<Cart> get cart => _cartSubject.stream;
  final BehaviorSubject<Cart> _cartSubject =
      BehaviorSubject.seeded(Cart.empty());

  void addToCart(Gallon gallon) {
    var currentCart = _cartSubject.value;
    // Need to verify if added product is from the same store as the others
    if (currentCart.products.isEmpty) {
      _cartSubject.add(currentCart.add(gallon));
    } else if (currentCart.products.isNotEmpty && currentCart.products.last.store.id == gallon.store.id) {
      _cartSubject.add(currentCart.add(gallon));
    }
    // TODO: show an error dialog with DialogService
  }

  void printLength() {
    _logger.i('cart products: ${_cartSubject.value.products.length}');
  }
}
