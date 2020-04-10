import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/order.dart';
import 'package:refresco/core/models/payment_method.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/services/cart_service.dart';
import 'package:refresco/core/services/order/order_service.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/locator.dart';
import 'package:refresco/ui/widgets/order_error_dialog.dart';
import 'package:refresco/ui/widgets/order_success_dialog.dart';
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
      _closePanel();
    } else {
      _openPanel();
    }
  }

  Future<bool> assesPop() async {
    if (panelController.isPanelClosed) {
      return true;
    } else {
      await _closePanel();
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
    /// TODO: validate order
    ///   1 - Check if user address
    ///   2 - Check if user is logged in (show popup to register/login)
    ///   3 - Check all user info is set (show popup to finish registration)
    bool valid = true;
    if (!user?.isValid ?? false) {
      print('User is invalid');
      valid = false;
    }
    if (!user?.address?.isValid ?? false) {
      print('Address is invalid');
      valid = false;
    }
    if (!user?.address?.coordinate?.isValid ?? false) {
      print('Coordinates are invalid');
      valid = false;
    }
    if (!valid) return;

    final order = Order.create(cart: cart, buyer: user);

    final response = await orderService.createOrder(order);

    if (response.success) {
      await Get.dialog(OrderSuccessDialog());
      cartService.clearCart();
      _closePanel();
    } else {
      Get.dialog(OrderErrorDialog(
        errorTitle: response.errorTitle,
        errorMessage: response.errorMessage,
      ));
    }

    setState(ViewState.idle);
  }

  double _interval(double lower, double upper, double progress) {
    assert(lower < upper);

    if (progress > upper) return 1.0;
    if (progress < lower) return 0.0;

    return ((progress - lower) / (upper - lower)).clamp(0.0, 1.0);
  }

  void _closePanel() async {
    if (panelController.panelPosition > 0.98) {
      await panelController.animatePanelToPosition(0,
          duration: animationDuration, curve: Curves.ease);
    }
  }

  void _openPanel() async {
    if (panelController.panelPosition < 0.98) {
      await panelController.animatePanelToPosition(1,
          duration: animationDuration, curve: Curves.ease);
    }
  }
}
