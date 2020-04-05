import 'package:get/get.dart';
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
      panelController.animatePanelToPosition(0, duration: animationDuration);
      return false;
    }
  }

  void goToStore(Store store) async {
    Get.toNamed(StoreViewRoute, arguments: store);
  }

  double _interval(double lower, double upper, double progress) {
    assert(lower < upper);

    if (progress > upper) return 1.0;
    if (progress < lower) return 0.0;

    return ((progress - lower) / (upper - lower)).clamp(0.0, 1.0);
  }
}
