import 'package:get/get.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/utils/routing_constants.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class CartSheetModel extends BaseModel {
  // Controllers
  SheetController sheetController = SheetController();

  double cartSheetScrollProgress = 0;
  double cartSheetOpacity = 1;

  void sheetListener(SheetState state) {
    cartSheetScrollProgress = state.progress;
    cartSheetOpacity = 1 - _interval(0.6, 0.95, cartSheetScrollProgress);
    sheetController.rebuild();
  }

  void toggleCart() {
    if (sheetController.state?.isCollapsed ?? false ||
        sheetController.state == null) {
      sheetController.expand();
    } else if (sheetController.state?.isExpanded ?? false) {
      sheetController.collapse();
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
