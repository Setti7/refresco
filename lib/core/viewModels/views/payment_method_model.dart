import 'package:get/get.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/models/payment_method.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/ui/widgets/change_bottom_sheet.dart';

class PaymentMethodModel extends BaseModel {
  Cart cart;

  void setPaymentMethod(PaymentMethod paymentMethod) async {

    // If the payment method is money, we need to set the change too.
    if (paymentMethod.type == null) {
      final change = await Get.bottomSheet<int>(
        isScrollControlled: true,
        builder: (context) {
          return ChangeBottomSheet(cart: cart);
        },
      );

      // Change is null if the user closed the bottom sheet or confirmed that
      // does not need it.
      if (change != null) {
        final newPaymentMethod = paymentMethod.clone(change: change);
        Get.back(result: newPaymentMethod);
      }
    } else {
      Get.back(result: paymentMethod);
    }
  }
}
