import 'package:logger/logger.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/services/dialog/dialog_service.dart';
import 'package:refresco/locator.dart';
import 'package:refresco/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

class CartService {
  DialogService dialogService = locator<DialogService>();

  final Logger _logger = getLogger('CartService');

  // Streams
  Observable<Cart> get cart => _cartSubject.stream;
  final BehaviorSubject<Cart> _cartSubject =
      BehaviorSubject.seeded(Cart.empty());

  bool addToCart(Gallon gallon) {
    var currentCart = _cartSubject.value;

    // Need to verify if added product is from the same store as the others
    if (currentCart.products.isEmpty) {
      _cartSubject.add(currentCart.add(gallon));
      return true;
    } else if (currentCart.products.isNotEmpty &&
        currentCart.products.last.store.id == gallon.store.id) {
      _cartSubject.add(currentCart.add(gallon));
      return true;
    } else {
      return false;
    }
  }

  void printLength() {
    _logger.i('cart products: ${_cartSubject.value.products.length}');
  }
}
