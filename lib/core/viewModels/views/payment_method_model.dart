import 'package:get/get.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/dataModels/payment_method.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/ui/widgets/change_bottom_sheet.dart';

class PaymentMethodModel extends BaseModel {
  Cart cart;

  void setPaymentMethod(PaymentMethod paymentMethod) async {
    if (paymentMethod.type == null) {
      final change = await Get.bottomSheet(
        isScrollControlled: true,
        builder: (context) {
          return ChangeBottomSheet(cart: cart);
        },
      );
      if (change != null) {
        paymentMethod.change = change;
        Get.back(result: paymentMethod);
      }
    } else {
      Get.back(result: paymentMethod);
    }
  }
}
