import 'package:flutter_base/core/viewModels/base_model.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class CartSheetModel extends BaseModel {
  // Controllers
  SheetController sheetController = SheetController();

  double cartSheetScrollProgress = 0;
  double cartSheetOpacity = 1;

  void sheetListener(SheetState state) {
    cartSheetScrollProgress = state.progress;
    cartSheetOpacity = 1 - _interval(0.7, 1.0, cartSheetScrollProgress);
    sheetController.rebuild();
  }

  void toggleCart() {
    if (sheetController.state?.isCollapsed == true ||
        sheetController.state == null) {
      sheetController.expand();
    } else if (sheetController.state?.isExpanded == true) {
      sheetController.collapse();
    }
  }

  double _interval(double lower, double upper, double progress) {
    assert(lower < upper);

    if (progress > upper) return 1.0;
    if (progress < lower) return 0.0;

    return ((progress - lower) / (upper - lower)).clamp(0.0, 1.0);
  }
}
