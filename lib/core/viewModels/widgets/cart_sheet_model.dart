import 'package:get/get.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/payment_method.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/services/cart/cart_service.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/locator.dart';
import 'package:refresco/utils/routing_constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CartSheetModel extends BaseModel {
  CartService cartService = locator<CartService>();
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

  double _interval(double lower, double upper, double progress) {
    assert(lower < upper);

    if (progress > upper) return 1.0;
    if (progress < lower) return 0.0;

    return ((progress - lower) / (upper - lower)).clamp(0.0, 1.0);
  }
}
