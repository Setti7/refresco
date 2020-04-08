import 'package:get/get.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/dataModels/payment_method.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/utils/routing_constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CartSheetModel extends BaseModel {
  Duration animationDuration = Duration(milliseconds: 300);

  // Controllers
  PanelController panelController;

  double cartSheetScrollProgress = 0;
  double cartSheetOpacity = 1;
  PaymentMethod paymentMethod;

  void sheetListener(double progress) {
    cartSheetScrollProgress = progress;
    cartSheetOpacity = 1 - _interval(0.6, 0.95, cartSheetScrollProgress);
    setState(ViewState.idle);
  }

  void toggleCart() {
    if (panelController.panelPosition > 0.98) {
      panelController.animatePanelToPosition(0, duration: animationDuration);
    } else {
      panelController.animatePanelToPosition(1, duration: animationDuration);
    }
  }

  Future<bool> assesPop() async {
    if (panelController.isPanelClosed) {
      return true;
    } else {
      await panelController.animatePanelToPosition(0, duration: animationDuration);
      return false;
    }
  }

  void goToStore(Store store) async {
    await Get.toNamed(Router.StoreViewRoute, arguments: store);
  }

  void selectPaymentMethod(Cart cart) async {
    final _method = await Get.toNamed(
      Router.PaymentMethodViewRoute,
      arguments: cart,
    ) as PaymentMethod;

    if (_method == null) {
      return;
    }

    paymentMethod = _method;
  }

  double _interval(double lower, double upper, double progress) {
    assert(lower < upper);

    if (progress > upper) return 1.0;
    if (progress < lower) return 0.0;

    return ((progress - lower) / (upper - lower)).clamp(0.0, 1.0);
  }
}
