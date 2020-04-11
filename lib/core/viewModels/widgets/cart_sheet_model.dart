import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/order.dart';
import 'package:refresco/core/models/payment_method.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/services/auth/auth_service.dart';
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
  AuthService authService = locator<AuthService>();
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
    final order = await _validateAndCreateOrder(cart, user);
    if (order == null) return null;

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

  Future<Order> _validateAndCreateOrder(Cart cart, User user) async {
    bool valid = true;
    User updatedUser = user;

    // If user is anonymous he needs to log in
    if (user.isAnonymous) {
      await Get.dialog(OrderErrorDialog(
        errorTitle: 'Crie uma conta!',
        errorMessage:
            'Para poder fazer compras pelo nosso app, você deve estar registrado e logado antes.',
        button1: RaisedButton(
          child: Text('Criar conta'),
          onPressed: () async {
            await Get.toNamed(Router.LoginViewRoute);
            Get.back();
          },
        ),
      ));

      updatedUser = authService.getUser();
      valid = updatedUser.isValid;
    }

    // Checking is user is valid
    if (!updatedUser.isValid) {
      await Get.dialog(OrderErrorDialog(
        errorTitle: 'Termine sua conta',
        errorMessage:
            'Para poder fazer compras pelo nosso app, você tem que terminar seu registro.',
        button1: RaisedButton(
          child: Text('Ok'),
          onPressed: () async {
            await Get.toNamed(Router.FinishRegistrationRoute);
            Get.back();
          },
        ),
      ));

      updatedUser = authService.getUser();
      valid = updatedUser.isValid;
    }

    if (!updatedUser.address.isValid) {
      Get.dialog(OrderErrorDialog(
        errorTitle: 'O endereço escolhido é inválido',
        errorMessage: 'Por favor, selecione ele denovo.',
      ));
      // TODO: set address to null
      valid = false;
    }
    if (!valid) return null;
    return Order.create(cart: cart, buyer: updatedUser);
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
