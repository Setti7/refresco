import 'package:get/get.dart';
import 'package:graphql/client.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/order.dart';
import 'package:refresco/core/models/payment_method.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/services/api/graphql_api.dart';
import 'package:refresco/core/services/cart_service.dart';
import 'package:refresco/core/services/order/order_service.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/locator.dart';
import 'package:refresco/utils/routing_constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CartSheetModel extends BaseModel {
  CartService cartService = locator<CartService>();
  OrderService orderService = locator<OrderService>();
  Duration animationDuration = Duration(milliseconds: 300);

  // Controllers
  PanelController panelController;

  double cartSheetScrollProgress = 0;
  double cartSheetOpacity = 1;

  void sheetListener(double progress) {
    cartSheetScrollProgress = progress;
    cartSheetOpacity = 1 - _interval(0.6, 0.95, cartSheetScrollProgress);
    setState(ViewState.idle);
  }

  void toggleCart() {
    if (panelController.panelPosition > 0.98) {
      // TODO: change curve
      panelController.animatePanelToPosition(0, duration: animationDuration);
    } else {
      panelController.animatePanelToPosition(1, duration: animationDuration);
    }
  }

  Future<bool> assesPop() async {
    if (panelController.isPanelClosed) {
      return true;
    } else {
      await panelController.animatePanelToPosition(0,
          duration: animationDuration);
      return false;
    }
  }

  void goToStore(Store store) async {
    await Get.toNamed(Router.StoreViewRoute, arguments: store);
  }

  void selectPaymentMethod(Cart cart) async {
    final _paymentMethod = await Get.toNamed(
      Router.PaymentMethodViewRoute,
      arguments: cart,
    ) as PaymentMethod;

    if (_paymentMethod == null) {
      return;
    }

    cartService.setPaymentMethod(_paymentMethod);
  }

  void createOrder(Cart cart, User user) async {
    /// TODO: validate user
    ///   1 - Check if user address
    ///   2 - Check if user is logged in (show popup to register/login)
    ///   3 - Check all user info is set (show popup to finish registration)

    if (user.id == null) throw Exception('User cannot be null');
    if (user.address == null) throw Exception('User address cannot be null');
    if (cart == null) throw Exception('Cart cannot be null');
    if (cart.store.id == null) throw Exception('Store cannot be null');
    if (cart.paymentMethod == null) throw Exception('PaymentMethod cannot be null');
    if (cart.products == null) throw Exception('Products cannot be null');

    final order = Order.create(cart: cart, buyer: user);

    final response = await orderService.initOrder(order);

    if (response.success) {
      print('waht');
    } else {
      print('Error as expected...');
      print(response.errorTitle);
      print(response.errorMessage);
    }

    print(order.toJson());
  }

  double _interval(double lower, double upper, double progress) {
    assert(lower < upper);

    if (progress > upper) return 1.0;
    if (progress < lower) return 0.0;

    return ((progress - lower) / (upper - lower)).clamp(0.0, 1.0);
  }
}
